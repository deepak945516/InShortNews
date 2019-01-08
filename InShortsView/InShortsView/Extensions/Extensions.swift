//
//  Extensions.swift
//  Play
//
//  Created by Deepak Kumar on 28/12/18.
//  Copyright © 2018 deepak. All rights reserved.
//

import Foundation
import UIKit

var activityIndicator: UIActivityIndicatorView?

// MARK: - UIView Extension
extension UIView {
    func makeCircle() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true
    }

    func dropShadow(shadowRadius: CGFloat = 5, shadowOffset: CGSize = .zero) {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = 1.0
        self.layer.shouldRasterize = true
    }


    func addBlurEffect() {
        let blurView = UIVisualEffectView()
        blurView.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        self.addSubview(blurView)
        blurView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
    }

    func showActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator?.color = UIColor.black
        activityIndicator?.hidesWhenStopped = true
        self.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
        activityIndicator?.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
    }

    func hideActivityIndicator() {
        activityIndicator?.stopAnimating()
    }


    // MARK: - Constraints with program
    func fillSuperview() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }

    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }

    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }

        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }

        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }

        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }

        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}


// MARK: - UIViewController Extension
extension UIViewController {
    func getViewController(storyboardName: String, viewControllerName: String) -> UIViewController {
        let viewController = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: viewControllerName)
        return viewController
    }
}
