//
//  InShortsViewController.swift
//  CALayer
//
//  Created by Deepak Kumar on 07/01/19.
//  Copyright © 2019 deepak. All rights reserved.
//

import UIKit

class InShortsViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var frontViewContainer: UIView!
    @IBOutlet weak var frontContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var frontContainseViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backViewContainer: UIView!
    @IBOutlet weak var backContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backContainseViewBottomConstraint: NSLayoutConstraint!

    var isFront: Bool = true
    let offset: CGFloat = 200
    var backViewController: BackViewController?
    var frontViewController: FrontViewController?
    var dataArray: [Results]?
    var currentArrayIndex: Int = 0
    var isNavigationBarVisible: Bool = true

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
        layoutSetup()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Private Methods
    private func initialSetup() {
        view.showActivityIndicator()
        // Add Child View Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        backViewController = storyboard.instantiateViewController(withIdentifier: "BackViewController") as? BackViewController
        addChildView(viewController: backViewController!, in: backViewContainer)
        frontViewController = storyboard.instantiateViewController(withIdentifier: "FrontViewController") as? FrontViewController
        addChildView(viewController: frontViewController!, in: frontViewContainer)
        // Hit Api
        NetworkManager.newsApiCall(completion: { (result) in
            self.dataArray = result
            // Set initial data
            DispatchQueue.main.async {
                self.frontViewController?.overlayView.alpha = 0
                self.view.hideActivityIndicator()
                self.setData(for: 0, isFront: true)
                self.setData(for: 1, isFront: false)
            }
        })

        // Hide Navigation controller after 5 second
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (timer) in
            UIView.animate(withDuration: 0.5, animations: { () in
                self.frontViewController?.topViewTopConstraint.constant = -64
                self.backViewController?.topViewTopConstraint.constant = -64
                self.isNavigationBarVisible = false
            })
        })
    }

    private func layoutSetup() {
        // Add Pan Gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandled(_:)))
        view.addGestureRecognizer(panGesture)

        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandled(_:)))
        view.addGestureRecognizer(tapGesture)

        view.backgroundColor = UIColor.black

        backViewContainer.clipsToBounds = true
        backViewContainer.layer.cornerRadius = 20
        backViewContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        frontViewContainer.clipsToBounds = true
        frontViewContainer.layer.cornerRadius = 20
        frontViewContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private func addChildView(viewController: UIViewController, in view: UIView) {
        viewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        viewController.view.frame = view.bounds
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }

    // SET DATA
    private func setData(for index: Int, isFront: Bool) {
        if isFront {
            frontViewController?.newsImageView.sd_setImage(with: URL(string: dataArray![index].multimedia![1].url!), completed: nil)
            frontViewController?.newsHeadingLabel.text = dataArray![index].title
            frontViewController?.newsTextView.text = dataArray![index].abstract
            frontViewController?.footerCaptionLabel.text = dataArray![index].multimedia![1].caption
        } else {
            backViewController?.newsImageView.sd_setImage(with: URL(string: dataArray![index].multimedia![1].url!), completed: nil)
            backViewController?.newsHeadingLabel.text = dataArray![index].title
            backViewController?.newsTextView.text = dataArray![index].abstract
            backViewController?.footerCaptionLabel.text = dataArray![index].multimedia![1].caption
        }
    }

    @objc func tapGestureHandled(_ recognizer: UITapGestureRecognizer) {
        if isNavigationBarVisible {
            frontViewController?.topViewTopConstraint.constant = -64
            backViewController?.topViewTopConstraint.constant = -64
        } else {
            frontViewController?.topViewTopConstraint.constant = -20
            backViewController?.topViewTopConstraint.constant = -20
        }
        isNavigationBarVisible = !isNavigationBarVisible
    }

    @objc func panGestureHandled(_ recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocity(in: view)
        // Return for the down pan and firstNews or return for the the up pan and lastNews
        if (velocity.y > 0 && currentArrayIndex == 0) || (velocity.y < 0 && currentArrayIndex >= (dataArray!.count - 1)) {
            return
        }
        // True only for vertical pan
        if abs(velocity.y) > abs(velocity.x) {
            switch recognizer.state {
            case .began:
                if isFront {
                    //Down
                    if velocity.y > 0 {
                        setData(for: currentArrayIndex - 1, isFront: false)
                    } else if velocity.y < 0  { // UP
                        setData(for: currentArrayIndex + 1, isFront: false)
                    }
                } else {
                    // Down
                    if velocity.y > 0 {
                        setData(for: currentArrayIndex - 1, isFront: true)
                    } else if velocity.y < 0  { // UP
                        setData(for: currentArrayIndex + 1, isFront: true)
                    }
                }
            case .changed:
                if velocity.y > 0 {
                    if isFront {
                        UIView.animate(withDuration: 0.5, animations: { () in
                            self.backViewController?.overlayView.alpha = 0.6
                            self.frontContainerViewTopConstraint.constant = recognizer.translation(in: self.view).y
                            self.frontContainseViewBottomConstraint.constant = -self.frontContainerViewTopConstraint.constant
                        })
                    } else {
                        UIView.animate(withDuration: 0.5, animations: { () in
                            self.frontViewController?.overlayView.alpha = 0.6
                            self.backContainerViewTopConstraint.constant = recognizer.translation(in: self.view).y
                            self.backContainseViewBottomConstraint.constant = -self.backContainerViewTopConstraint.constant
                        })
                    }
                } else if velocity.y < 0 {
                    if isFront {
                        UIView.animate(withDuration: 0.5, animations: { () in
                            self.backViewController?.overlayView.alpha = 0.6
                            self.frontContainerViewTopConstraint.constant = recognizer.translation(in: self.view).y
                            self.frontContainseViewBottomConstraint.constant = -self.frontContainerViewTopConstraint.constant
                        })
                    } else {
                        UIView.animate(withDuration: 0.5, animations: { () in
                            self.frontViewController?.overlayView.alpha = 0.6
                            self.backContainerViewTopConstraint.constant = recognizer.translation(in: self.view).y
                            self.backContainseViewBottomConstraint.constant = -self.backContainerViewTopConstraint.constant
                        })
                    }
                }
            case .ended:
                if abs(recognizer.translation(in: view).y) > offset {
                    if isFront {
                        isFront = !isFront
                        UIView.animate(withDuration: 0.5, animations: { () in
                            self.frontContainerViewTopConstraint.constant = 20
                            self.frontContainseViewBottomConstraint.constant = 0
                            self.view.bringSubviewToFront(self.backViewContainer)
                            self.backViewController?.overlayView.alpha = 0
                        })
                    } else {
                        isFront = !isFront
                        UIView.animate(withDuration: 0.5, animations: { () in
                            self.backContainerViewTopConstraint.constant = 20
                            self.backContainseViewBottomConstraint.constant = 0
                            self.view.bringSubviewToFront(self.frontViewContainer)
                            self.frontViewController?.overlayView.alpha = 0
                        })
                    }
                    currentArrayIndex = velocity.y > 0 ? (currentArrayIndex - 1): (currentArrayIndex + 1)
                } else {
                    UIView.animate(withDuration: 0.5, animations: { () in
                        self.frontContainerViewTopConstraint.constant = 20
                        self.frontContainseViewBottomConstraint.constant = 0
                        self.backContainerViewTopConstraint.constant = 20
                        self.backContainseViewBottomConstraint.constant = 0
                    })
                }
            default:
                print("Other state==========")
            }
        }
    }
}
