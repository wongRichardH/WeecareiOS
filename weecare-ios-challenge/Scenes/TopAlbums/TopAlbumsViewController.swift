//
//  TopAlbumsViewController.swift
//  weecare-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import UIKit

final class TopAlbumsViewController: UIViewController {
    
    private let cache = NSCache<NSString, UIImage>()
    private let iTunesAPI: ITunesAPI
    private let networking: Networking
    private let tableView = UITableView()
    private var sectionTitle : String?

    private var albumListVM: AlbumListViewModel? {
        didSet {
            UIView.transition(with: tableView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { self.tableView.reloadData() })
            albumListVM?.delegate = self
        }
    }
    
    init(iTunesAPI: ITunesAPI, networking: Networking) {
        self.iTunesAPI = iTunesAPI
        self.networking = networking
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Top Albums"

        setupTableView()
        setupFilterButtons()
        loadData()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TopAlbumTableViewCell.self, forCellReuseIdentifier: TopAlbumTableViewCell.description())
        tableView.register(TopAlbumTableViewHeader.self,
               forHeaderFooterViewReuseIdentifier: "sectionHeader")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupFilterButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort ABC", style: .plain, target: self, action: #selector(sortAlphabeticalButtonTapped))

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort Date", style: .plain, target: self, action: #selector(sortReleaseDateButtonTapped))
    }

    private func loadData() {
        iTunesAPI.getTopAlbums(limit: 10) { [weak self] res in
            switch res {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.sectionTitle = data.feed.title
                    self?.albumListVM = AlbumListViewModel(albums: data.feed.results)

                    print(data.feed.results)
                }
            case .failure(let err):
                debugPrint(err)
            }
        }
    }
    
    private func downloadImage(url: String, completion: @escaping (Result<UIImage?, Error>) -> ()) {
        let request = APIRequest(url: url)
        networking.requestData(request) { res in
            completion(res.map { data in UIImage(data: data) })
        }
    }

}


//MARK: - Button UI Functions
extension TopAlbumsViewController {

    @objc func sortAlphabeticalButtonTapped() {
        guard var albumListVM = albumListVM else {return}
        albumListVM.sortAlbums(albumSort: .alphabetical)
    }

    @objc func sortReleaseDateButtonTapped() {
        guard var albumListVM = albumListVM else {return}

        albumListVM.sortAlbums(albumSort: .releaseDate)
    }
}

// MARK: - AlbumListViewModelDelegate
extension TopAlbumsViewController: AlbumListViewModelDelegate {
    func didLoadData(albumListVM: AlbumListViewModel) {
        self.albumListVM = albumListVM
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TopAlbumsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let albumListVM = self.albumListVM else {return 0}

        return albumListVM.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let albumListVM = self.albumListVM,
              let album = albumListVM.albumAtIndex(indexPath.row) else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: TopAlbumTableViewCell.description(), for: indexPath) as! TopAlbumTableViewCell

        cell.configure(with: album)
        
        if let imageURL = album.artworkUrl100 {
            if let img = cache.object(forKey: album.id as NSString) {
                cell.albumImageView.image = img
            } else {
                downloadImage(url: imageURL) { [weak self, weak cell] res in
                    switch res {
                    case .success(let img):
                        guard let img = img else { return }
                        self?.cache.setObject(img, forKey: album.id as NSString)
                        DispatchQueue.main.async {
                            cell?.albumImageView.image = img
                        }
                    case .failure(let err):
                        debugPrint(err)
                    }
                }
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                       "sectionHeader") as! TopAlbumTableViewHeader

        if let sectionTitle = self.sectionTitle {
            view.title.text = sectionTitle
        } else {
            view.title.text =  "loading ..."
        }

       return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}
