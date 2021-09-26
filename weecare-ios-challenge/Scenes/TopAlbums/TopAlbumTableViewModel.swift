//
//  TopAlbumTableViewModel.swift
//  weecare-ios-challenge
//
//  Created by Richard on 9/25/21.
//

import Foundation

enum AlbumSort {
    case alphabetical
//    case releaseDate
}

protocol AlbumListViewModelDelegate: AnyObject {
    func didLoadData(albumListVM: AlbumListViewModel)
}

struct AlbumListViewModel {
    var albums: [Album]?

    weak var delegate: AlbumListViewModelDelegate?

    var dateFormatter = DateFormatter()

    init(albums: [Album]) {
        self.albums = albums
    }
}
extension AlbumListViewModel {

    var numberOfSections: Int {
        return 1
    }

    func numberOfRowsInSection(_ section: Int) -> Int {

        guard let albums = self.albums else {return 0}
        return albums.count
    }

    func albumAtIndex(_ index: Int) -> Album? {
        guard let albums = albums else {return nil}
        guard index >= 0 && index < albums.count else {return nil}

        return albums[index]
    }

    mutating func sortAlbums(albumSort: AlbumSort) {

        print("reached delegate!")

        guard let albums = self.albums else {return}

        var sortedAlbum = albums

        switch albumSort {
        case .alphabetical:
            sortedAlbum = sortedAlbum.sorted(by: {$0.name < $1.name})

//        case .releaseDate:
        }

        delegate?.didLoadData(albumListVM: AlbumListViewModel(albums: sortedAlbum))
    }
}

