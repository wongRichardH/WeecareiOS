//
//  InsetLabel.swift
//  weecare-ios-challenge
//
//  Created by Richard on 9/29/21.
//

import Foundation
import UIKit

class InsetLabel: UILabel {

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        super.drawText(in: rect.inset(by: insets))
    }

}
