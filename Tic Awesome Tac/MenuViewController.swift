//
//  MenuViewController.swift
//  Tic Awesome Tac
//
//  Created by Denis Dobynda on 16/03/2017.
//  Copyright © 2017 Denis Dobynda. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            }
        case "Show 6":
            if let destinationVC = segue.destination as? GameViewController {
                destinationVC.n = 6
            }
        case "Show 9":
            if let destinationVC = segue.destination as? GameViewController {
                destinationVC.n = 9
            }
        case "Show 12":
            if let destinationVC = segue.destination as? GameViewController {
                destinationVC.n = 12
            }
        default:
            if let destinationVC = segue.destination as? GameViewController {
                destinationVC.n = 0
            }
        }
    }


}
