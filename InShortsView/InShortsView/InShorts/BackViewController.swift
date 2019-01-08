//
//  BackViewController.swift
//  CALayer
//
//  Created by Deepak Kumar on 07/01/19.
//  Copyright © 2019 deepak. All rights reserved.
//

import UIKit

class BackViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsHeadingLabel: UILabel!
    @IBOutlet weak var newsTextView: UITextView!
    @IBOutlet weak var footerCaptionLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Private Methods
    private func initialSetup() {

    }

    // MARK: - IBAction Methods
    @IBAction func moreButtonTapped(_ sender: UIButton) {

    }

    @IBAction func reloadButtonTapped(_ sender: UIButton) {
        print("Reload")
    }
}
