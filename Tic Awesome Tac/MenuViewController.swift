//
//  MenuViewController.swift
//  Tic Awesome Tac
//
//  Created by Denis Dobynda on 16/03/2017.
//  Copyright © 2017 Denis Dobynda. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UISplitViewControllerDelegate {

    // for the UISplitViewControllerDelegate method below to work
    // we have to set ourself as the UISplitViewController's delegate
    // (only we can be that because ImageViewControllers come and goes from the heap)
    // we could probably get away with doing this as late as viewDidLoad
    // but it's a bit safer to do it as early as possible
    // and this is as early as possible
    // (we just came out of the storyboard and "awoke"
    // so we know we are in our UISplitViewController by now)
    override func awakeFromNib() {
        super.awakeFromNib()
        self.splitViewController?.delegate = self
    }

    public var tutorial: UIImage? = nil

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

        // Do any additional setup after loading the view.
    }
    override var prefersStatusBarHidden : Bool {
      return true
    }

    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeLeft
    }
    private func shouldAutorotate() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier! {
        case "Show 3":
            if let destinationVC = segue.destination as? GameViewController {
                destinationVC.n = 3
                destinationVC.title = "3 x 3"
            }
        case "Show 6":
            if let destinationVC = segue.destination as? GameViewController {
                destinationVC.n = 6
                destinationVC.title = "6 X 6"
            }
        case "Show 9":
            if let destinationVC = segue.destination as? GameViewController {
                destinationVC.n = 9
                destinationVC.title = "9 x 9"
            }
        case "Show 12":
            if let destinationVC = segue.destination as? GameViewController {
                destinationVC.n = 12
                destinationVC.title = "12 x 12"
            }
        default:
            if let destinationVC = segue.destination.contents as? ImageViewController {
                if tutorial != nil {
                    destinationVC.tutorial = tutorial
                }
                destinationVC.sub = self
            }
            break
        }
    }

    // we "fake out" iOS here
    // this delegate method of UISplitViewController
    // allows the delegate to do the work of collapsing the primary view controller (the master)
    // on top of the secondary view controller (the detail)
    // this happens whenever the split view wants to show the detail
    // but the master is on screen in a spot that would be covered up by the detail
    // the return value of this delegate method is a Bool
    // "true" means "yes, Mr. UISplitViewController, I did collapse that for you"
    // "false" means "sorry, Mr. UISplitViewController, I couldn't collapse so you do it for me"
    // if our secondary (detail) is an ImageViewController with a nil imageURL
    // then we will return true even though we're not actually going to do anything
    // that's because when imageURL is nil, we do NOT want the detail to collapse on top of the master
    // (that's the whole point of this)
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
        ) -> Bool {
        if primaryViewController.contents == self {
            if let ivc = secondaryViewController.contents as? ImageViewController, ivc.tutorial == nil {
                return true
            }
        }
        return false
    }

}


extension UIViewController
{
    // a friendly var we've added to UIViewController
    // it returns the "contents" of this UIViewController
    // which, if this UIViewController is a UINavigationController
    // means "the UIViewController contained in me (and visible)"
    // otherwise, it just means the UIViewController itself
    // could easily imagine extending this for UITabBarController too
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
