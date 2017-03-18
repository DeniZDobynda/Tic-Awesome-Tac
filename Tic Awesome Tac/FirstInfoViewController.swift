//
//  FirstInfoViewController.swift
//  Tic Awesome Tac
//
//  Created by Denis Dobynda on 17/03/2017.
//  Copyright © 2017 Denis Dobynda. All rights reserved.
//

import UIKit

class FirstInfoViewController: UIViewController {

    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeLeft
    }
    private func shouldAutorotate() -> Bool {
        return true
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        let tutorial = UIImage.gifImageWithName(name: "tutorial")
        let imageView = UIImageView(image: tutorial)
        imageView.frame = CGRect(x: 20.0, y: 50.0, width: self.view.frame.size.width - 40, height: self.view.frame.size.width - 40)
        view.addSubview(imageView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clear(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
