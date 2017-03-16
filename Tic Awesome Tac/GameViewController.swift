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

    private var winner: UIButton = UIButton()

    override func viewDidLoad() {
        game = Game(size: 4)
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

    }

    func winner(button: UIButton) {
        view.subviews.forEach({ $0.removeFromSuperview() })
        game = Game(size: 4)
        winner = UIButton()
        self.viewDidLoad()
    }

    func pressButton(button: UIButton) {
        let split = button.currentTitle!.components(separatedBy: ":")
        let i = Int(split[0])!
        let j = Int(split[1])!

        let right_b = UIImage(named: "dash_right_black.png") as UIImage?

        let left_b = UIImage(named: "dash_left_black.png") as UIImage?

        //let size = game.size * 2

        let response = game.move(i: i, j: j, id: 1)
        
        if ( response != nil ) {

            let array = response!.components(separatedBy: "^")

            if ( array[1] == "1" ) {
                //win!
                winner = UIButton(frame: CGRect(x: 0 , y: 0 , width: view.bounds.maxX, height: view.bounds.maxY))
                let image = UIImage(named: "cross.png")
                winner.setBackgroundImage(image, for: .normal)
                winner.addTarget(self, action: #selector(winner(button:)), for: .touchUpInside)
                self.view.addSubview(winner)

            } else if ( array[1] == "-1" ) {
                //loss
                winner = UIButton(frame: CGRect(x: 0 , y: 0 , width: view.bounds.maxX, height: view.bounds.maxY))
                let image = UIImage(named: "circle.png")
                winner.setBackgroundImage(image, for: .normal)
                winner.addTarget(self, action: #selector(winner(button:)), for: .touchUpInside)
                self.view.addSubview(winner)

            }
            if ( array[0] != "") {

                let string = array[0].components(separatedBy: "|")

                var k = 0
                while ( k < string.count ) {
                    let size = game.size * 2

                    let b = view.bounds.maxX > view.bounds.maxY ? view.bounds.maxY : view.bounds.maxX

                    let measure = (Int(b)-20) / size

                    let x = Int(view.bounds.midX) - measure*game.size
                    let y = Int(view.bounds.midY) - measure*game.size


                    let situation = string[k].components(separatedBy: "-")[0]
                    switch situation {
                    case "1", "3":
                        let button = UIButton(frame: CGRect(x: x + j*measure - measure, y: y + i*measure - measure, width: measure*2, height: measure*2))
                        let image = UIImage(named: "cross.png")
                        button.setBackgroundImage(image, for: .normal)
                        self.view.addSubview(button)

                    case "2", "4":
                        let button = UIButton(frame: CGRect(x: x + j*measure , y: y + i*measure , width: measure*2, height: measure*2))
                        let image = UIImage(named: "cross.png")
                        button.setBackgroundImage(image, for: .normal)
                        self.view.addSubview(button)

                    case "5", "7":
                        let button = UIButton(frame: CGRect(x: x + j*measure , y: y + i*measure - measure, width: measure*2, height: measure*2))
                        let image = UIImage(named: "cross.png")
                        button.setBackgroundImage(image, for: .normal)
                        self.view.addSubview(button)

                    case "6", "8":
                        let button = UIButton(frame: CGRect(x: x + j*measure - measure , y: y + i*measure , width: measure*2, height: measure*2))
                        let image = UIImage(named: "cross.png")
                        button.setBackgroundImage(image, for: .normal)
                        self.view.addSubview(button)

                    default:
                        print(situation)
                    }
                    k+=1
                }
            } else {
                //move is not worthy
                repeat {
                    let iRespond = game.makeBestMove()

                    if ( iRespond != nil ) {

                        let array = iRespond!.components(separatedBy: "^")

                        let coordinates = array[2].components(separatedBy: ":")
                        let ii = Int(coordinates[0]) ?? 0
                        let jj = Int(coordinates[1]) ?? 0

                        if ( array[1] == "-1" ) {
                            //win!
                            winner = UIButton(frame: CGRect(x: 0 , y: 0 , width: view.bounds.maxX, height: view.bounds.maxY))
                            let image = UIImage(named: "cross.png")
                            winner.setBackgroundImage(image, for: .normal)
                            winner.addTarget(self, action: #selector(winner(button:)), for: .touchUpInside)
                            self.view.addSubview(winner)

                        } else if ( array[1] == "1" ) {
                            //loss
                            winner = UIButton(frame: CGRect(x: 0 , y: 0 , width: view.bounds.maxX, height: view.bounds.maxY))
                            let image = UIImage(named: "circle.png")
                            winner.setBackgroundImage(image, for: .normal)
                            winner.addTarget(self, action: #selector(winner(button:)), for: .touchUpInside)
                            self.view.addSubview(winner)

                        }
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
                                    let image = UIImage(named: "circle.png")
                                    button.setBackgroundImage(image, for: .normal)
                                    self.view.addSubview(button)

                                case "2", "4":
                                    let button = UIButton(frame: CGRect(x: x + jj*measure , y: y + ii*measure , width: measure*2, height: measure*2))
                                    let image = UIImage(named: "circle.png")
                                    button.setBackgroundImage(image, for: .normal)
                                    self.view.addSubview(button)

                                case "5", "7":
                                    let button = UIButton(frame: CGRect(x: x + jj*measure , y: y + ii*measure - measure, width: measure*2, height: measure*2))
                                    let image = UIImage(named: "circle.png")
                                    button.setBackgroundImage(image, for: .normal)
                                    self.view.addSubview(button)
                                    
                                case "6", "8":
                                    let button = UIButton(frame: CGRect(x: x + jj*measure - measure , y: y + ii*measure , width: measure*2, height: measure*2))
                                    let image = UIImage(named: "circle.png")
                                    button.setBackgroundImage(image, for: .normal)
                                    self.view.addSubview(button)
                                    
                                default:
                                    print(situation)
                                }
                                k+=1
                            }
                        }


                        if ( (ii+jj) % 2 == 0 ) {
                            //right
                            buttons[ii][jj].setImage(right_b, for: .normal)
                        } else {
                            //left
                            buttons[ii][jj].setImage(left_b, for: .normal)
                        }
                        buttons[ii][jj].removeTarget(nil, action: nil, for: .allEvents)

                    }

                }
                while(!game.move)
            }

            if ( (i+j) % 2 == 0 ) {
                //right
                buttons[i][j].setImage(right_b, for: .normal)
            } else {
                buttons[i][j].setImage(left_b, for: .normal)
            }
            buttons[i][j].removeTarget(nil, action: nil, for: .allEvents)
                //game.store(db:db)
                //game.load(db:db)

        }

    }

}

