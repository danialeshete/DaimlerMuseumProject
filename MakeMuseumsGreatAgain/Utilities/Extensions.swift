//
//  Helpers.swift
//  MakeMuseumsGreatAgain
//
//  Created by Niklas Schildhauer on 04.12.21.
//

import Foundation
import UIKit

extension UIView {
    
    public func anchorToAllEdgesOfSuperview(insets: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate([
            self.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.leadingAnchor, constant: insets.left),
            self.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.trailingAnchor, constant: -insets.right),
            self.safeAreaLayoutGuide.topAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.topAnchor, constant: insets.top),
            self.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom)
        ])
    }
    
    public func blurBackground(behind view: UIView) {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.insertSubview(blurEffectView, belowSubview: view)
    }
}


extension UIViewController {
    func add(childViewController: UIViewController, insets: UIEdgeInsets = .zero) {
        childViewController.willMove(toParent: self)
        addChild(childViewController)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
        childViewController.view.anchorToAllEdgesOfSuperview(insets: insets)
    }
}
