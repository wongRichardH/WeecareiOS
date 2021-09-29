//
//  TopAlbumTableViewModel.swift
//  weecare-ios-challenge
//
//  Created by Richard on 9/25/21.
//

import Foundation

enum AlbumSort {
    case alphabetical
    case releaseDate
}

protocol AlbumListViewModelDelegate: AnyObject {
    func didLoadData(albumListVM: AlbumListViewModel)
}

struct AlbumListViewModel {
    var albums: [Album]?
    var dateFormatter = DateConverter()

    weak var delegate: AlbumListViewModelDelegate?

    init(albums: [Album]) {
        self.albums = albums
    }
}

//MARK: -- TableView functions
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
        guard let albums = self.albums else {return}

        var sortedAlbum = albums

        switch albumSort {
        case .alphabetical:
            sortedAlbum = sortedAlbum.sorted(by: {$0.name < $1.name})

        case .releaseDate:
            if let releaseSorted = sortReleaseDate(albums: sortedAlbum) {
                sortedAlbum = releaseSorted
            }
        }

        delegate?.didLoadData(albumListVM: AlbumListViewModel(albums: sortedAlbum))
    }


    func sortReleaseDate(albums: [Album]) -> [Album]? {

        var tupleAlbumDate: [(Album, Date)] = []

        for eachAlbum in albums {
            let isoDate = eachAlbum.releaseDate

            if let date = dateFormatter.convertDatesWithUniqueFormatter(dateString: isoDate) {
                tupleAlbumDate.append((eachAlbum, date))
            }
        }

        guard tupleAlbumDate.count > 0 else {return nil}

        tupleAlbumDate.sort(by: {$0.1 < $1.1})
        var sortedReleaseAlbum = [Album]()

        for eachTupleDate in tupleAlbumDate {
            sortedReleaseAlbum.append(eachTupleDate.0)
        }

        return sortedReleaseAlbum
    }
}

