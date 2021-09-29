//
//  TopAlbumTableViewHeader.swift
//  weecare-ios-challenge
//
//  Created by Richard on 9/25/21.
//

import Foundation
import UIKit

class TopAlbumTableViewHeader: UITableViewHeaderFooterView {

    let title = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
       }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {

        contentView.backgroundColor = UIColor.white

        configureConstraints()
        configureFontStyle()
    }

   func configureConstraints() {
       title.translatesAutoresizingMaskIntoConstraints = false

       contentView.addSubview(title)

        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor,
                      constant: 0),
               title.trailingAnchor.constraint(equalTo:
                      contentView.layoutMarginsGuide.trailingAnchor, constant: 8),
               title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
           ])
   }

    func configureFontStyle() {
        title.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
    }

}
