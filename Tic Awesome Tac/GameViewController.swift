//
//  ViewController.swift
//  Tic Awesome Tac
//
//  Created by Denis Dobynda on 15/03/2017.
//  Copyright © 2017 Denis Dobynda. All rights reserved.
//

import UIKit

//extension UIView {
//
//    var identifier: GameViewController {
//        get {
//            return getAssociatedValue(key: "identifier", object: self, initialValue: GameViewController())
//        }
//        set {
//            set(associatedValue: newValue, key: "identifier", object: self)
//        }
//    }
//}

//extension UIView {
//
//    func changeScale(recognizer: UIPinchGestureRecognizer) {
//        switch recognizer.state {
//        case .changed, .ended:
//            identifier.scale *= recognizer.scale
//            recognizer.scale = 1.0
//        default:
//            break
//        }
//    }
//}

class GameViewController: UIViewController, UIScrollViewDelegate {

    public var scale: CGFloat = 1.0 {
        didSet {
            reDraw()
        }
    }

    private var buttons = [[UIButton]]()

    private var game = Game(1)

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

    private var moveFieldsIndexesDashes = [(Int, Int, Int, Bool)]()
    private var moveFields = [UIButton]()

    private var didLastMoveWasUsers: Bool = true
    private var gameScrollView = UIScrollView()
    private var gameView = UIView()
//    {
//        didSet {
//            view.identifier = self
//            view.addGestureRecognizer(
//                UIPinchGestureRecognizer(target: view, action: #selector( UIView.changeScale(recognizer:) ) )
//            )
//        }
//    }


    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return gameView
    }

//    func changeScale(recognizer: UIPinchGestureRecognizer) {
//        switch recognizer.state {
//        case .changed, .ended:
//            gameView.zoomScale *= recognizer.scale
//            recognizer.scale = 1.0
//        default:
//            break
//        }
//    }

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

    private let defaultWallSize: CGSize = CGSize(width: 100, height: 100)


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        game = Game(n!)
        lastMoveDashes = [(Int, Int)]()
        lastMoveFields = [UIButton]()
        lastMoveFiledsIndexes = [Int]()
        moveFieldsIndexesDashes = [(Int, Int, Int, Bool)]()
        moveFields = [UIButton]()
        didLastMoveWasUsers = true



//        gameView = UIScrollView(frame: CGRect(x: (view.bounds.maxX - triangleSide)/2 , y: (view.bounds.maxY - triangleSide)/2, width: triangleSide, height: triangleSide))


        let size = n! * 2


        let content = CGSize(width: CGFloat(size) * defaultWallSize.width, height: CGFloat(size) * defaultWallSize.height)

        gameView = UIView(frame: CGRect(origin: CGPoint(x:0, y:0), size: content))



//        gameView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI/4))
//        gameView.transform = CGAffineTransform.identity
        gameView.backgroundColor = UIColor.white
//        self.view.addSubview(gameView)


        let measure: Int = Int(defaultWallSize.width) //Int(triangleSide) / size

        let x = 0//Int(gameView.bounds.midX) - measure*n!
        let y = 0//Int(gameView.bounds.midY) - measure*n!

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



                gameView.addSubview(buttons[i][j])
            }
        }


        reDraw()


    }

    private func reDraw() {
//        gameView.removeFromSuperview()

//        let b = min(view.bounds.maxX, view.bounds.maxY)

//        let triangleSide = sqrt((b*b)/2) * scale

//        gameView = UIScrollView(frame: CGRect(x: (view.bounds.maxX - triangleSide)/2 , y: (view.bounds.maxY - triangleSide)/2, width: triangleSide, height: triangleSide))
//        gameView = UIScrollView(frame: view.bounds )

//        gameView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI/4))
        //gameView.backgroundColor = UIColor.gray


        let size = n! * 2

        let measure: Int = Int(defaultWallSize.width)

        let x = 0//Int(gameView.bounds.midX) - measure*n!
        let y = 0//Int(gameView.bounds.midY) - measure*n!

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

                
                
                gameView.addSubview(buttons[i][j])
            }
        }

        for k in 0..<moveFields.count {
            let i = moveFieldsIndexesDashes[k].0
            let j = moveFieldsIndexesDashes[k].1
            var stored = false
            for l in 0..<lastMoveFields.count {
                if lastMoveFields[l].backgroundImage(for: .normal)?.hashValue == moveFields[k].backgroundImage(for: .normal)?.hashValue {
                    lastMoveFields[l] = moveFields[k]
                    stored = true
                }
            }
            moveFields[k].removeFromSuperview()
            switch moveFieldsIndexesDashes[k].2 {
            case 1:
                moveFields[k] = UIButton(frame: CGRect(x: x + j*measure - measure, y: y + i*measure - measure, width: measure*2, height: measure*2))
            case 2:
                moveFields[k] = UIButton(frame: CGRect(x: x + j*measure , y: y + i*measure , width: measure*2, height: measure*2))
            case 7:
                moveFields[k] = UIButton(frame: CGRect(x: x + j*measure , y: y + i*measure - measure, width: measure*2, height: measure*2))
            case 8:
                moveFields[k] = UIButton(frame: CGRect(x: x + j*measure - measure , y: y + i*measure , width: measure*2, height: measure*2))
            default:
                break
            }
            if moveFieldsIndexesDashes[k].3 {
                if !stored {
                    moveFields[k].setImage(UIImage(named: "cross_black.png"), for: .normal)
                } else {
                    moveFields[k].setImage(UIImage(named: "cross.png"), for: .normal)
                }
            } else {
                if !stored {
                    moveFields[k].setImage(UIImage(named: "circle_black.png"), for: .normal)
                } else {
                    moveFields[k].setImage(UIImage(named: "circle.png"), for: .normal)
                }
            }
            gameView.addSubview(moveFields[k])

        }

        if didLastMoveWasUsers {
            for (i,j) in lastMoveDashes {
                if ( (i+j) % 2 == 0 ) {
                    //right
                    buttons[i][j].setImage(UIImage(named: "dash_right_red.png"), for: .normal)
                } else {
                    buttons[i][j].setImage(UIImage(named: "dash_left_red.png"), for: .normal)
                }
            }
        } else {
            for (i,j) in lastMoveDashes {
                if ( (i+j) % 2 == 0 ) {
                    //right
                    buttons[i][j].setImage(UIImage(named: "dash_right_blue.png"), for: .normal)
                } else {
                    buttons[i][j].setImage(UIImage(named: "dash_left_blue.png"), for: .normal)
                }
            }
        }


        //adding ability to magnify

//        gameView.scrollRectToVisible(CGRect(origin: CGPoint(x: 0, y: 0), size: content), animated: false)





        let visibleView = CGRect(
            origin: CGPoint(x: 0.0, y: navigationController?.navigationBar.bounds.height ?? 0.0),
            size: CGSize(width: view.bounds.size.width, height: view.bounds.size.height - (navigationController?.navigationBar.bounds.height ?? 0.0) )
        )


        let content = CGSize(
            width: max(CGFloat(size) * defaultWallSize.width, visibleView.width),
            height: max(CGFloat(size) * defaultWallSize.height, visibleView.height)
        )


        gameScrollView = UIScrollView(frame: visibleView)

        gameScrollView.contentSize = content

        gameScrollView.delegate = self
        gameScrollView.minimumZoomScale = gameScrollView.bounds.width / gameScrollView.contentSize.width
        gameScrollView.maximumZoomScale = 1.0
        gameScrollView.zoomScale = gameScrollView.minimumZoomScale
        //print(gameView.maximumZoomScale, gameView.minimumZoomScale)

        gameScrollView.addSubview(gameView)

        self.view.addSubview(gameScrollView)

    }


    func winner(button: UIButton) {
        gameView.subviews.forEach({ $0.removeFromSuperview() })
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        game = Game(n!)
        winner = UIButton()
        didWon = "0"
        self.view.backgroundColor = UIColor.white
        gameView.backgroundColor = UIColor.white
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
//                    let size = n! * 2

//                    let b = min(gameView.bounds.maxX, gameView.bounds.maxY)

                    let measure: Int = Int(defaultWallSize.width) //let measure = Int(b) / size

                    let x = 0//Int(gameView.bounds.midX) - measure*n!
                    let y = 0//Int(gameView.bounds.midY) - measure*n!


                    let situation = string[k].components(separatedBy: "-")[0]
                    switch situation {
                    case "1", "3":
                        let button = UIButton(frame: CGRect(x: x + j*measure - measure, y: y + i*measure - measure, width: measure*2, height: measure*2))
                        button.setBackgroundImage(UIImage(named: "cross.png"), for: .normal)
                        gameView.addSubview(button)
                        lastMoveFields.append(button)
                        lastMoveFiledsIndexes.append(lastMoveFields.count)

                        moveFieldsIndexesDashes.append((i,j,1, true))
                        moveFields.append(button)

                    case "2", "4":
                        let button = UIButton(frame: CGRect(x: x + j*measure , y: y + i*measure , width: measure*2, height: measure*2))
                        button.setBackgroundImage(UIImage(named: "cross.png"), for: .normal)
                        gameView.addSubview(button)
                        lastMoveFields.append(button)
                        lastMoveFiledsIndexes.append(lastMoveFields.count)

                        moveFieldsIndexesDashes.append((i,j,2, true))
                        moveFields.append(button)

                    case "5", "7":
                        let button = UIButton(frame: CGRect(x: x + j*measure , y: y + i*measure - measure, width: measure*2, height: measure*2))
                        button.setBackgroundImage(UIImage(named: "cross.png"), for: .normal)
                        gameView.addSubview(button)
                        lastMoveFields.append(button)
                        lastMoveFiledsIndexes.append(lastMoveFields.count)

                        moveFieldsIndexesDashes.append((i,j,7, true))
                        moveFields.append(button)

                    case "6", "8":
                        let button = UIButton(frame: CGRect(x: x + j*measure - measure , y: y + i*measure , width: measure*2, height: measure*2))
                        button.setBackgroundImage(UIImage(named: "cross.png"), for: .normal)
                        gameView.addSubview(button)
                        lastMoveFields.append(button)
                        lastMoveFiledsIndexes.append(lastMoveFields.count)

                        moveFieldsIndexesDashes.append((i,j,8, true))
                        moveFields.append(button)

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
            winner.setTitle("X - \(game.score.0)\tO - \(game.score.1)", for: .normal)
            winner.setTitleColor(UIColor.black, for: .normal)
            winner.backgroundColor = UIColor.cyan
            self.view.addSubview(winner)


        }

        if ( didWon == "1" ) {

            self.view.backgroundColor = UIColor.green
            gameView.backgroundColor = UIColor.green

            if didLastMoveWasUsers {
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
            } else {
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

        } else if didWon == "-1" {

            self.view.backgroundColor = UIColor.red
            gameView.backgroundColor = UIColor.red

            if  !didLastMoveWasUsers {
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
            } else {
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
//                    let size = n! * 2

//                    let b = gameView.bounds.maxX > gameView.bounds.maxY ? gameView.bounds.maxY : gameView.bounds.maxX

                    let measure: Int = Int(defaultWallSize.width) //let measure = Int(b) / size

                    let x = 0//Int(gameView.bounds.midX) - measure*n!
                    let y = 0//Int(gameView.bounds.midY) - measure*n!


                    let situation = string[k].components(separatedBy: "-")[0]
                    switch situation {
                    case "1", "3":
                        let button = UIButton(frame: CGRect(x: x + jj*measure - measure, y: y + ii*measure - measure, width: measure*2, height: measure*2))
                        button.setBackgroundImage(UIImage(named: "circle.png"), for: .normal)
                        gameView.addSubview(button)
                        lastMoveFields.append(button)
                        lastMoveFiledsIndexes.append(lastMoveFields.count)

                        moveFieldsIndexesDashes.append((ii,jj,1, false))
                        moveFields.append(button)

                    case "2", "4":
                        let button = UIButton(frame: CGRect(x: x + jj*measure , y: y + ii*measure , width: measure*2, height: measure*2))
                        button.setBackgroundImage(UIImage(named: "circle.png"), for: .normal)
                        self.gameView.addSubview(button)
                        lastMoveFields.append(button)
                        lastMoveFiledsIndexes.append(lastMoveFields.count)

                        moveFieldsIndexesDashes.append((ii,jj,2, false))
                        moveFields.append(button)

                    case "5", "7":
                        let button = UIButton(frame: CGRect(x: x + jj*measure , y: y + ii*measure - measure, width: measure*2, height: measure*2))
                        button.setBackgroundImage(UIImage(named: "circle.png"), for: .normal)
                        self.gameView.addSubview(button)
                        lastMoveFields.append(button)
                        lastMoveFiledsIndexes.append(lastMoveFields.count)

                        moveFieldsIndexesDashes.append((ii,jj,7, false))
                        moveFields.append(button)

                    case "6", "8":
                        let button = UIButton(frame: CGRect(x: x + jj*measure - measure , y: y + ii*measure , width: measure*2, height: measure*2))
                        button.setBackgroundImage(UIImage(named: "circle.png"), for: .normal)
                        self.gameView.addSubview(button)
                        lastMoveFields.append(button)
                        lastMoveFiledsIndexes.append(lastMoveFields.count)

                        moveFieldsIndexesDashes.append((ii,jj,8, false))
                        moveFields.append(button)
                        
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
