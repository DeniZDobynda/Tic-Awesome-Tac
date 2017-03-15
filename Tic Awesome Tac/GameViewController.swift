//
//  ViewController.swift
//  Tic Awesome Tac
//
//  Created by Denis Dobynda on 15/03/2017.
//  Copyright © 2017 Denis Dobynda. All rights reserved.
//

import UIKit
import CoreData

class GameViewController: UIViewController {

    var db: [NSManagedObject] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }

        let managedContext =
            appDelegate.persistentContainer.viewContext

        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Matrix")

        //3
        do {
            db = try managedContext.fetch(fetchRequest)
            if ( db.count == 0 ) {
                let entity = NSEntityDescription.entity(forEntityName: "Matrix", in: managedContext)!
                db.append(NSManagedObject(entity: entity, insertInto: managedContext))
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    private var buttons = [[UIButton]]()

    private var game = Game(size: 1)

    override func viewDidLoad() {
        game = Game(size: 3)
        //game.load()


        let size = game.size * 2

        let b = view.bounds.maxX > view.bounds.maxY ? view.bounds.maxY : view.bounds.maxX

        let measure = (Int(b)-20) / size

        let x = Int(view.bounds.midX) - measure*game.size
        let y = Int(view.bounds.midY) - measure*game.size

        buttons = Array(repeating: Array(repeating: UIButton(), count: size), count: size)

        let right = UIImage(named: "dash_right_gray.png") as UIImage?

        let right_b = UIImage(named: "dash_right_black.png") as UIImage?

        let left = UIImage(named: "dash_left_gray.png") as UIImage?

        let left_b = UIImage(named: "dash_left_black.png") as UIImage?

        for i in 0..<size {
            for j in 0..<size {

                buttons[i][j] = UIButton(frame: CGRect(x: x + j*measure, y: y + i*measure, width: measure, height: measure))
                buttons[i][j].setTitle("\(i):\(j)", for: .normal)

                if ( (i+j) % 2 == 0 ) {
                    //right
                    if ( i == 0 || j == 0 || i == size-1 || j == size-1 || game.isOccupied(i: i, j: j)) {
                        buttons[i][j].setImage(right_b, for: .normal)
                    } else {
                        buttons[i][j].setImage(right, for: .normal)
                    }
                } else {
                    //left
                    if ( i == 0 || j == 0 || i == size-1 || j == size-1 || game.isOccupied(i: i, j: j)) {
                        buttons[i][j].setImage(left_b, for: .normal)
                    } else {
                        buttons[i][j].setImage(left, for: .normal)
                    }
                }

                buttons[i][j].addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)

                self.view.addSubview(buttons[i][j])
            }
        }

    }

    func pressButton(button: UIButton) {
        let split = button.currentTitle!.components(separatedBy: ":")
        let i = Int(split[0])!
        let j = Int(split[1])!

        let right_b = UIImage(named: "dash_right_black.png") as UIImage?

        let left_b = UIImage(named: "dash_left_black.png") as UIImage?

        let size = game.size * 2

        let response = game.move(i: i, j: j, id: 1)

        let array = response?.components(separatedBy: "^")

        if ( array?[0] != "" ) {
            let size = game.size * 2

            let b = view.bounds.maxX > view.bounds.maxY ? view.bounds.maxY : view.bounds.maxX

            let measure = (Int(b)-20) / size

            let x = Int(view.bounds.midX) - measure*game.size
            let y = Int(view.bounds.midY) - measure*game.size


            let situation = array![0].components(separatedBy: "-")[0]
            switch situation {
            case "1":
                let button = UIButton(frame: CGRect(x: x + j*measure - measure/2, y: y + i*measure - measure/2, width: measure, height: measure))
                let image = UIImage(named: "cross.png")
                button.setBackgroundImage(image, for: .normal)
                self.view.addSubview(button)
            default:
                print(situation)
            }
        }

        if ( (i+j) % 2 == 0 ) {
            //right
            if ( i == 0 || j == 0 || i == size-1 || j == size-1) {
                buttons[i][j].setImage(right_b, for: .normal)
            } else {
                buttons[i][j].setImage(right_b, for: .normal)
            }
        } else {
            //left
            if ( i == 0 || j == 0 || i == size-1 || j == size-1) {
                buttons[i][j].setImage(left_b, for: .normal)
            } else {
                buttons[i][j].setImage(left_b, for: .normal)
            }
        }
        //game.store(db:db)
        //game.load(db:db)
    }

}

