//
//  ViewController.swift
//  Tic Awesome Tac
//
//  Created by Denis Dobynda on 15/03/2017.
//  Copyright © 2017 Denis Dobynda. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    private var buttons = [[UIButton]]()

    private var game = Game(size: 1)

    public var n: Int?

    private var didWon: String = "0"
    //    {
    //        willSet {
    //            NSLog("Game: \(game.toString()) ( win:\(newValue))")
    //        }
    //    }

    private var lastMoveDashes = [(Int, Int)]()
    private var lastMoveFields = [UIButton]()
    private var lastMoveFiledsIndexes = [Int]()
    private var didLastMoveWasUsers: Bool = true

    private var moveAI: Bool = false {
        willSet {
            if ( newValue == true ) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    self.move()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        self.check()
                    })
                })
            }
        }
    }

    private var winner: UIButton = UIButton()

    private var exit: UIButton = UIButton()

    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {return UIInterfaceOrientationMask.landscapeLeft}

    private func shouldAutorotate() -> Bool {return true}

    override var prefersStatusBarHidden : Bool {return true}

    override func viewDidLoad() {
        game = Game(size: n!)
        lastMoveDashes = [(Int, Int)]()
        lastMoveFields = [UIButton]()
        lastMoveFiledsIndexes = [Int]()
        didLastMoveWasUsers = true

        self.view.backgroundColor = UIColor.white

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
                        buttons[i][j].addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
                    }
                } else {
                    //left
                    if ( i == 0 || j == 0 || i == size-1 || j == size-1 || game.isOccupied(i: i, j: j)) {
                        buttons[i][j].setImage(left_b, for: .normal)
                    } else {
                        buttons[i][j].setImage(left, for: .normal)
                        buttons[i][j].addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
                    }
                }



                self.view.addSubview(buttons[i][j])
            }
        }

        let height = x < y ? y - 20 : x - 20
        exit = UIButton(frame: CGRect(x: 10, y: 10, width: height, height: height))
        exit.setImage(UIImage(named: "home.jpg"), for: .normal)
        exit.addTarget(self, action: #selector(close(button:)), for: .touchUpInside)

        self.view.addSubview(exit)


    }

    func close(button: UIButton) {
        //self.navigationController!.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    func winner(button: UIButton) {
        view.subviews.forEach({ $0.removeFromSuperview() })
        game = Game(size: n!)
        winner = UIButton()
        self.viewDidLoad()
    }

    func pressButton(button: UIButton) {
        if moveAI == true {
            return
        }

        if ( !didLastMoveWasUsers ) {
            for (i,j) in lastMoveDashes {
                if ( (i+j) % 2 == 0 ) {
                    //right
                    buttons[i][j].setImage(UIImage(named: "dash_right_black.png"), for: .normal)
                } else {
                    buttons[i][j].setImage(UIImage(named: "dash_left_black.png"), for: .normal)
                }
            }
            for i in lastMoveFiledsIndexes {
                lastMoveFields[i-1].setImage(UIImage(named: "circle_black.png"), for: .normal)
            }
            lastMoveDashes = [(Int, Int)]()
            lastMoveFiledsIndexes = [Int]()
            didLastMoveWasUsers = true

        } else {
            //            lastMoveDashes = [(Int, Int)]()
            //            lastMoveFiledsIndexes = [Int]()
            //            didLastMoveWasUsers = true
        }


        let split = button.currentTitle!.components(separatedBy: ":")
        let i = Int(split[0])!
        let j = Int(split[1])!

        lastMoveDashes.append((i,j))


        if ( (i+j) % 2 == 0 ) {
            //right
            buttons[i][j].setImage(UIImage(named: "dash_right_red.png"), for: .normal)
        } else {
            buttons[i][j].setImage(UIImage(named: "dash_left_red.png"), for: .normal)
        }
        buttons[i][j].removeTarget(nil, action: nil, for: .allEvents)


        let response = game.move(i: i, j: j, id: 1)

        if ( response != nil ) {

            let array = response!.components(separatedBy: "^")

            ////////////////////////
            didWon = array[1]

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.check()
            })

            ////////////////////////

            if ( array[0] != "") {

                let string = array[0].components(separatedBy: "|")

                var k = 0
                while ( k < string.count - 1 ) {
                    let size = game.size * 2

                    let b = view.bounds.maxX > view.bounds.maxY ? view.bounds.maxY : view.bounds.maxX

                    let measure = (Int(b)-20) / size

                    let x = Int(view.bounds.midX) - measure*game.size
                    let y = Int(view.bounds.midY) - measure*game.size


                    let situation = string[k].components(separatedBy: "-")[0]
                    switch situation {
                    case "1", "3":
                        let button = UIButton(frame: CGRect(x: x + j*measure - measure, y: y + i*measure - measure, width: measure*2, height: measure*2))
                        button.setBackgroundImage(UIImage(named: "cross.png"), for: .normal)
                        self.view.addSubview(button)
                        lastMoveFields.append(button)
                        lastMoveFiledsIndexes.append(lastMoveFields.count)

                    case "2", "4":
                        let button = UIButton(frame: CGRect(x: x + j*measure , y: y + i*measure , width: measure*2, height: measure*2))
                        button.setBackgroundImage(UIImage(named: "cross.png"), for: .normal)
                        self.view.addSubview(button)
                        lastMoveFields.append(button)
                        lastMoveFiledsIndexes.append(lastMoveFields.count)

                    case "5", "7":
                        let button = UIButton(frame: CGRect(x: x + j*measure , y: y + i*measure - measure, width: measure*2, height: measure*2))
                        button.setBackgroundImage(UIImage(named: "cross.png"), for: .normal)
                        self.view.addSubview(button)
                        lastMoveFields.append(button)
                        lastMoveFiledsIndexes.append(lastMoveFields.count)

                    case "6", "8":
                        let button = UIButton(frame: CGRect(x: x + j*measure - measure , y: y + i*measure , width: measure*2, height: measure*2))
                        button.setBackgroundImage(UIImage(named: "cross.png"), for: .normal)
                        self.view.addSubview(button)
                        lastMoveFields.append(button)
                        lastMoveFiledsIndexes.append(lastMoveFields.count)

                    default:
                        print("situation (r): "+response!)
                    }
                    k+=1
                }
            } else {
                //move is not worthy
                for (i,j) in lastMoveDashes {
                    if ( (i+j) % 2 == 0 ) {
                        //right
                        buttons[i][j].setImage(UIImage(named: "dash_right_black.png"), for: .normal)
                    } else {
                        buttons[i][j].setImage(UIImage(named: "dash_left_black.png"), for: .normal)
                    }
                }
                for i in lastMoveFiledsIndexes {
                    lastMoveFields[i-1].setImage(UIImage(named: "cross_black.png"), for: .normal)
                }
                lastMoveDashes = [(Int, Int)]()
                lastMoveFiledsIndexes = [Int]()
                didLastMoveWasUsers = false
                moveAI = true
            }


        }

    }

    private func check() {

        if ( didWon != "0"){
            winner = UIButton(frame: CGRect(x: 10 , y: view.bounds.maxY - abs(view.bounds.maxY-view.bounds.maxX)/2, width: view.bounds.maxX-20, height: abs(view.bounds.maxY-view.bounds.maxX)/2 - 20))
            //winner.setBackgroundImage(UIImage(named: "again.png"), for: .normal)
            winner.addTarget(self, action: #selector(winner(button:)), for: .touchUpInside)
            winner.setTitle("X - \(game.score.0)\tY - \(game.score.1)", for: .normal)
            winner.setTitleColor(UIColor.black, for: .normal)
            winner.backgroundColor = UIColor.cyan
            self.view.addSubview(winner)
        }

        if ( didWon == "1" ) {

            self.view.backgroundColor = UIColor.green

            if ( didLastMoveWasUsers) {
                for (i,j) in lastMoveDashes {
                    if ( (i+j) % 2 == 0 ) {
                        //right
                        buttons[i][j].setImage(UIImage(named: "dash_right_black.png"), for: .normal)
                    } else {
                        buttons[i][j].setImage(UIImage(named: "dash_left_black.png"), for: .normal)
                    }
                }
                for i in lastMoveFiledsIndexes {
                    lastMoveFields[i-1].setImage(UIImage(named: "cross_black.png"), for: .normal)
                }
            }

        } else if ( didWon == "-1" ) {

            self.view.backgroundColor = UIColor.red

            if ( !didLastMoveWasUsers) {
                for (i,j) in lastMoveDashes {
                    if ( (i+j) % 2 == 0 ) {
                        //right
                        buttons[i][j].setImage(UIImage(named: "dash_right_black.png"), for: .normal)
                    } else {
                        buttons[i][j].setImage(UIImage(named: "dash_left_black.png"), for: .normal)
                    }
                }
                for i in lastMoveFiledsIndexes {
                    lastMoveFields[i-1].setImage(UIImage(named: "circle_black.png"), for: .normal)
                }
            }
        }
    }

    private func move() {

        let iRespond = game.makeBestMove()

        if ( iRespond != nil ) {

            let array = iRespond!.components(separatedBy: "^")

            let coordinates = array[2].components(separatedBy: ":")
            let ii = Int(coordinates[0]) ?? 0
            let jj = Int(coordinates[1]) ?? 0

            lastMoveDashes.append((ii, jj))

            ////////////////////////
            switch array[1] {
            case "-1":
                didWon = "1"
            case "1":
                didWon = "-1"
            default:
                break
            }
            /////////////////////////

            if ( array[0] != "") {

                let string = array[0].components(separatedBy: "|")



                var k = 0
                while ( k < string.count && string[k] != "" ) {
                    let size = game.size * 2

                    let b = view.bounds.maxX > view.bounds.maxY ? view.bounds.maxY : view.bounds.maxX

                    let measure = (Int(b)-20) / size

                    let x = Int(view.bounds.midX) - measure*game.size
                    let y = Int(view.bounds.midY) - measure*game.size


                    let situation = string[k].components(separatedBy: "-")[0]
                    switch situation {
                    case "1", "3":
                        let button = UIButton(frame: CGRect(x: x + jj*measure - measure, y: y + ii*measure - measure, width: measure*2, height: measure*2))
                        button.setBackgroundImage(UIImage(named: "circle.png"), for: .normal)
                        self.view.addSubview(button)
                        lastMoveFields.append(button)
                        lastMoveFiledsIndexes.append(lastMoveFields.count)

                    case "2", "4":
                        let button = UIButton(frame: CGRect(x: x + jj*measure , y: y + ii*measure , width: measure*2, height: measure*2))
                        button.setBackgroundImage(UIImage(named: "circle.png"), for: .normal)
                        self.view.addSubview(button)
                        lastMoveFields.append(button)
                        lastMoveFiledsIndexes.append(lastMoveFields.count)

                    case "5", "7":
                        let button = UIButton(frame: CGRect(x: x + jj*measure , y: y + ii*measure - measure, width: measure*2, height: measure*2))
                        button.setBackgroundImage(UIImage(named: "circle.png"), for: .normal)
                        self.view.addSubview(button)
                        lastMoveFields.append(button)
                        lastMoveFiledsIndexes.append(lastMoveFields.count)

                    case "6", "8":
                        let button = UIButton(frame: CGRect(x: x + jj*measure - measure , y: y + ii*measure , width: measure*2, height: measure*2))
                        button.setBackgroundImage(UIImage(named: "circle.png"), for: .normal)
                        self.view.addSubview(button)
                        lastMoveFields.append(button)
                        lastMoveFiledsIndexes.append(lastMoveFields.count)
                        
                    default:
                        print("situation: "+iRespond!)
                    }
                    k+=1
                }
            }
            
            if ( (ii+jj) % 2 == 0 ) {
                //right
                buttons[ii][jj].setImage(UIImage(named: "dash_right_blue.png"), for: .normal)
            } else {
                //left
                buttons[ii][jj].setImage(UIImage(named: "dash_left_blue.png"), for: .normal)
            }
            buttons[ii][jj].removeTarget(nil, action: nil, for: .allEvents)
            
            moveAI = !game.move
        }
    }
    
}

