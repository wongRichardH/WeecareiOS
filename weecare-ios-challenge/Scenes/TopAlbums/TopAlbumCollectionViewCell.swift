//
//  TopAlbumCollectionViewCell.swift
//  weecare-ios-challenge
//
//  Created by Richard on 9/29/21.
//

import Foundation
import UIKit

class TopAlbumCollectionViewCell: UICollectionViewCell {

    let albumImageView = UIImageView()

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()

    let stackView = UIStackView()

    let albumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    let artistNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .heavy)
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()

    var newAlbumLabel: InsetLabel = {
        let label = InsetLabel()
        label.text = "NEW"

        label.textColor = UIColor(red: 0.85, green: 0.75, blue: 0.51, alpha: 1.00)
        label.font = UIFont.italicSystemFont(ofSize: 10)
        label.textAlignment = .center

        label.backgroundColor = UIColor.white
        label.layer.cornerRadius = 5.0
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.masksToBounds = true

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        contentView.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.clear

        //Corner Radius, Shadow
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath

        albumImageView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        albumImageView.contentMode = .scaleToFill

        stackView.axis = .vertical
        stackView.addArrangedSubview(albumLabel)
        stackView.addArrangedSubview(artistNameLabel)
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading

        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        [albumImageView, stackView, newAlbumLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }

        let albumHeight = albumImageView.heightAnchor.constraint(equalToConstant: 150)

        let newAlbumLabelHeight = newAlbumLabel.heightAnchor.constraint(equalToConstant: 15)
        let newAlbumLabelWidth = newAlbumLabel.widthAnchor.constraint(equalToConstant: 30)

        NSLayoutConstraint.activate([
            // Container View
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

            //Recent Album Release Image
            newAlbumLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            newAlbumLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            newAlbumLabelHeight,
            newAlbumLabelWidth,

            // Album Image View
            albumImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            albumImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            albumImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            albumHeight,

            // Stack
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }

    func configure(with album: Album) {
        self.albumLabel.text = "\"\(album.name)\""
        self.artistNameLabel.text = album.artistName

        determineAlbumRecencyLabel(releaseDate: album.releaseDate)
    }

    // Highlights corresponding UILabel if release date is within a week
    func determineAlbumRecencyLabel(releaseDate: String) {
        if let date = DateConverter().convertDatesWithUniqueFormatter(dateString: releaseDate) {
            if Calendar.current.isDateInThisWeek(date) {
                newAlbumLabel.isHidden = false
            } else {
                newAlbumLabel.isHidden = true
            }
        }
    }
}
