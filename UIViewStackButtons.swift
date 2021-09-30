//
//  UIViewStackButtons.swift
//  weecare-ios-challenge
//
//  Created by Richard on 9/29/21.
//

import Foundation
import UIKit

class UIViewStackButtons: UIView {

    var containerView: UIView = {
        let view = UIView()
        return view
    }()

    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 2
        return stack
    }()

    override init(frame: CGRect) {
         super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }

    private func commonInit() {

        self.layer.masksToBounds = false
        self.layer.cornerRadius = 4
        self.clipsToBounds = true

        containerView.backgroundColor = .white

        self.addSubview(containerView)
        containerView.addSubview(stackView)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }

    func configure(with buttons: [UIButton]) {
        for eachButton in buttons {
            eachButton.setTitleColor(UIColor.black, for: .normal)
            eachButton.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(eachButton)
        }
    }
}
