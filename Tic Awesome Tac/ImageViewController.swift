//
//  FirstInfoViewController.swift
//  Tic Awesome Tac
//
//  Created by Denis Dobynda on 17/03/2017.
//  Copyright © 2017 Denis Dobynda. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {return UIInterfaceOrientationMask.landscapeLeft}
    private func shouldAutorotate() -> Bool {return true}
    override var prefersStatusBarHidden : Bool {return true}

    public var tutorial: UIImage? = nil
    public weak var sub: UIViewController? = nil

    private var tutorialView: UIImageView? = nil

    @IBAction func clear(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if ( tutorial == nil) {

            let loading = UILabel(frame: CGRect(x: 20.0, y: 50.0, width: self.view.frame.size.width - 40, height: self.view.frame.size.width - 40))
            loading.text = "Making tutorial... Please, wait."
            loading.textColor = UIColor.black
            loading.backgroundColor = UIColor.cyan
            view.addSubview(loading)

            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.tutorial = UIImage.gifImageWithName(name: "tutorial")


                DispatchQueue.main.sync { [weak self] in
                    let imageView = UIImageView(image: self?.tutorial)
                    imageView.frame = CGRect(x: 20.0, y: 50.0, width: (self?.view.frame.size.width)! - 40, height: (self?.view.frame.size.width)! - 40)
                    self?.view.willRemoveSubview(loading)
                    self?.view.addSubview(imageView)
                    if let view = self?.sub as? MenuViewController {
                        view.tutorial = self?.tutorial
                    }

                }


                
            }
/*
            // Move to a background thread to do some long running work
            DispatchQueue.global(qos: .utility).async {
                let img = UIImage.gifImageWithName(name: "tutorial")

                // Bounce back to the main thread to update the UI
                DispatchQueue.main.async {
                    let imageView = UIImageView(image: img)
                    imageView.frame = CGRect(x: 20.0, y: 50.0, width: self.view.frame.size.width - 40, height: self.view.frame.size.width - 40)
                    self.view.willRemoveSubview(loading)
                    self.view.addSubview(imageView)
                    self.tutorial = img
                    if let view = self.sub as? MenuViewController {
                        view.tutorial = img
                    }
                }
            }
        */
        } else {
            let imageView = UIImageView(image: tutorial)
            imageView.frame = CGRect(x: 20.0, y: 50.0, width: self.view.frame.size.width - 40, height: self.view.frame.size.width - 40)
            view.addSubview(imageView)
        }

    }

}
