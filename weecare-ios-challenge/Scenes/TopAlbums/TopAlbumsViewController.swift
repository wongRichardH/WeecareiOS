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
//    private let tableView = UITableView()
    private var sectionTitle : String?

    private var collectionView: UICollectionView!

    private var albumListVM: AlbumListViewModel? {
        didSet {
            UIView.transition(with: collectionView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { self.collectionView.reloadData() })
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

        setupNavigationBar()
        setupCollectionView()
        setupFilterButtons()
        loadData()
    }

    func setupNavigationBar() {
        navigationItem.title = "Top Albums"
        navigationController?.navigationBar.barTintColor = UIColor.black

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

//    private func setupTableView() {
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.register(TopAlbumTableViewCell.self, forCellReuseIdentifier: TopAlbumTableViewCell.description())
//        tableView.register(TopAlbumTableViewHeader.self,
//                           forHeaderFooterViewReuseIdentifier: Constants.CellIdentifiers.TopAlbumsViewControllerTableHeader)
//        view.addSubview(tableView)
//
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//        ])
//    }

    private func setupCollectionView() {

        let cellHeight = view.frame.size.height/3
        let cellWidth = (view.frame.width/2 - 15)

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)

        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.backgroundColor = UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1.00)

        collectionView.register(TopAlbumCollectionViewCell.self, forCellWithReuseIdentifier: "default")

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension TopAlbumsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let albumListVM = self.albumListVM else {return 0}

        return albumListVM.numberOfRowsInSection(section)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let albumListVM = self.albumListVM else {return 0}
        return albumListVM.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let albumListVM = self.albumListVM, let album = albumListVM.albumAtIndex(indexPath.row) else {
            return UICollectionViewCell.init()

       }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath) as! TopAlbumCollectionViewCell

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


}

//// MARK: - UITableViewDataSource, UITableViewDelegate
//extension TopAlbumsViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let albumListVM = self.albumListVM else {return 0}
//
//        return albumListVM.numberOfRowsInSection(section)
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let albumListVM = self.albumListVM,
//              let album = albumListVM.albumAtIndex(indexPath.row) else {
//            return UITableViewCell()
//        }
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: TopAlbumTableViewCell.description(), for: indexPath) as! TopAlbumTableViewCell
//
//        cell.configure(with: album)
//
//        if let imageURL = album.artworkUrl100 {
//            if let img = cache.object(forKey: album.id as NSString) {
//                cell.albumImageView.image = img
//            } else {
//                downloadImage(url: imageURL) { [weak self, weak cell] res in
//                    switch res {
//                    case .success(let img):
//                        guard let img = img else { return }
//                        self?.cache.setObject(img, forKey: album.id as NSString)
//                        DispatchQueue.main.async {
//                            cell?.albumImageView.image = img
//                        }
//                    case .failure(let err):
//                        debugPrint(err)
//                    }
//                }
//            }
//        }
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
//                                                                Constants.CellIdentifiers.TopAlbumsViewControllerTableHeader) as! TopAlbumTableViewHeader
//
//        if let sectionTitle = self.sectionTitle {
//            view.title.text = sectionTitle
//        } else {
//            view.title.text =  "loading ..."
//        }
//
//       return view
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 350
//    }
//}
