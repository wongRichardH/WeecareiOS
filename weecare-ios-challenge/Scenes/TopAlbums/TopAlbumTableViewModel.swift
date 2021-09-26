//
//  TopAlbumTableViewModel.swift
//  weecare-ios-challenge
//
//  Created by Richard on 9/25/21.
//

import Foundation

private enum AlbumSort {
    case alphabetical
//    case releaseDate
}


struct AlbumListViewModel {
    var albums: [Album]

    var dateFormatter = DateFormatter()
}
extension AlbumListViewModel {

    var numberOfSections: Int {
        return 1
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.albums.count
    }

    func albumAtIndex(_ index: Int) -> Album? {
        guard index >= 0 && index < self.albums.count else {return nil}

        return self.albums[index]
    }

    private mutating func sortAlbums(albums: [Album], albumSort: AlbumSort) {


        var sortedAlbum = albums

        switch albumSort {
        case .alphabetical:
            sortedAlbum = sortedAlbum.sorted(by: {$0.name < $1.name})

//        case .releaseDate:


        default:
            break
        }

        self.albums = sortedAlbum
    }

}

