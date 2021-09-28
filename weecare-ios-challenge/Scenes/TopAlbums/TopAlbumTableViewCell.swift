//
//  TopAlbumTableViewCell.swift
//  weecare-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import UIKit

class TopAlbumTableViewCell: UITableViewCell {
    
    let albumImageView = UIImageView()
    let containerView = UIView()
    let stackView = UIStackView()
    let albumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 36)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let artistNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedSystemFont(ofSize: 24, weight: .heavy)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    let releaseDateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedSystemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        albumImageView.makeRounded()
    }
    
    private func commonInit() {
        albumImageView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        albumImageView.contentMode = .scaleToFill

        stackView.axis = .vertical
        stackView.addArrangedSubview(albumImageView)
        stackView.addArrangedSubview(albumLabel)
        stackView.addArrangedSubview(artistNameLabel)
        stackView.addArrangedSubview(releaseDateLabel)
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        [albumImageView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        let albumHeight = albumImageView.heightAnchor.constraint(equalToConstant: 200)
        let albumWidth = albumImageView.widthAnchor.constraint(equalToConstant: 200)

        NSLayoutConstraint.activate([
            // Container View
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

            // Album Image View
            albumImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            albumImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            albumHeight,
            albumWidth,

            // Stack
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: albumImageView.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }

    func configure(with album: Album) {
        self.albumLabel.text = "\"\(album.name)\""
        self.artistNameLabel.text = album.artistName
        self.releaseDateLabel.text = album.releaseDate

        determineAlbumRecencyLabel(label: albumLabel, releaseDate: album.releaseDate)
    }

    // Highlights corresponding UILabel if release date is within a week
    func determineAlbumRecencyLabel(label: UILabel, releaseDate: String) {
        if let date = DateConverter().convertDatesWithUniqueFormatter(dateString: releaseDate) {
            if Calendar.current.isDateInThisWeek(date) {
                label.backgroundColor = UIColor.red
            } else {
                label.backgroundColor = UIColor.white
            }
        }
    }
}
