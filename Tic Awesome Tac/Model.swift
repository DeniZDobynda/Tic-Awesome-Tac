//
//  model.swift
//  Tic Awesome Tac
//
//  Created by Denis Dobynda on 15/03/2017.
//  Copyright © 2017 Denis Dobynda. All rights reserved.
//

import Foundation

class Matrix {
    private var dash: [[Int]] = [[Int]]()
    private var fields: [[Int]] = [[Int]]()
    private var fields_small: [[Int]] = [[Int]]()
    public var size = 0

    init(size: Int) {
        self.size = size

        dash = Array(repeating: Array(repeating: 0, count: size*2), count: size*2)
        for i in 0..<size*2 {

            self.dash[i] = Array(repeating: 0, count: size*2)
            if ( i == 0 || i == size*2-1) {
                self.dash[i] = Array(repeating: 1, count: size*2)
            } else {
                self.dash[i][0] = 1
                self.dash[i][size*2-1] = 1
            }
        }
        fields = Array(repeating: Array(repeating: 0, count: size), count: size)
//        for i in 0..<size {
//            self.fields[i] = Array(repeating: 0, count: size)
//        }

        fields_small = Array(repeating: Array(repeating: 0, count: size-1), count: size-1)
//        for i in 0..<size-1 {
//            self.fields_small[i] = Array(repeating: 0, count: size-1)
//        }
    }

    func putDash(i:Int, j:Int, id:Int) -> String {
        assert(i >= 1 || j >= 1 || i < (self.size*2)-2 || j < (self.size*2)-2)

        if (  didWon(id: id) == 1 ) {
            return "^1"
        }

        if ( self.dash[i][j] != 0 ) {
            return "^"
        } else {
            self.dash[i][j] = id
            return check(i: i, j: j, id: id)
        }
    }

    public func getFirstFreeSpace() -> (Int, Int) {
        for i in 1..<size*2-1 {
            for j in 1..<size*2-1 {
                if ( dash[i][j] == 0) {
                    return (i,j)
                }
            }
        }
        return (0,0)
    }

    private func check(i: Int, j: Int, id: Int) -> String {
        var result: String = ""
        if ( (i+j) % 2 == 0){
            // '/' variant

            if ( i % 2 == 1) {
                // 'main/sub' case
                if ( dash[i][j-1] != 0 && dash[i-1][j] != 0 && dash[i-1][j-1] != 0 ) {
                    if ( fields[i/2][j/2] == 0 ) {
                        fields[i/2][j/2] = id
                        result += "1-"+String(i/2)+":"+String(j/2)+"|"
                    }
                }
                if ( dash[i][j+1] != 0 && dash[i+1][j] != 0 && dash[i+1][j+1] != 0 ) {
                    if ( fields_small[i/2][j/2] == 0 ) {
                        fields_small[i/2][j/2] = id
                        result += "2-"+String(i/2)+":"+String(j/2)+"|"
                    }
                }
            } else {
                // 'sub/main' case
                if ( dash[i][j-1] != 0 && dash[i-1][j] != 0 && dash[i-1][j-1] != 0 ) {
                    if ( fields_small[i/2-1][j/2-1] == 0 ) {
                        fields_small[i/2-1][j/2-1] = id
                        result += "3-"+String(i/2-1)+":"+String(j/2-1)+"|"
                    }
                }
                if ( dash[i][j+1] != 0 && dash[i+1][j] != 0 && dash[i+1][j+1] != 0 ) {
                    if ( fields[i/2][j/2] == 0 ) {
                        fields[i/2][j/2] = id
                        result += "4-"+String(i/2)+":"+String(j/2)+"|"
                    }
                }
            }

        } else {
            // '\' variant

            if ( i % 2 == 1) {
                // 'sub\main' case
                if ( dash[i][j+1] != 0 && dash[i-1][j] != 0 && dash[i-1][j+1] != 0 ) {
                    if ( fields[i/2][j/2] == 0 ) {
                        fields[i/2][j/2] = id
                        result += "5-"+String(i/2)+":"+String(j/2)+"|"
                    }
                }
                if ( dash[i][j-1] != 0 && dash[i+1][j] != 0 && dash[i+1][j-1] != 0 ) {
                    if ( fields_small[i/2][j/2-1] == 0 ) {
                        fields_small[i/2][j/2-1] = id
                        result += "6-"+String(i/2)+":"+String(j/2-1)+"|"
                    }
                }
            } else {
                // 'main\sub' case
                if ( dash[i][j+1] != 0 && dash[i-1][j] != 0 && dash[i-1][j+1] != 0 ) {
                    if ( fields_small[i/2-1][j/2] == 0 ) {
                        fields_small[i/2-1][j/2] = id
                        result += "7-"+String(i/2-1)+":"+String(j/2)+"|"
                    }
                }
                if ( dash[i][j-1] != 0 && dash[i+1][j] != 0 && dash[i+1][j-1] != 0 ) {
                    if ( fields[i/2][j/2] == 0 ) {
                        fields[i/2][j/2] = id
                        result += "8-"+String(i/2)+":"+String(j/2)+"|"
                    }
                }
            }

        }
        return result + "^" + String(didWon(id: id))
    }

    private func didWon(id: Int) -> Int {
        for i in 0..<size-1 {
            if ( fields_small[i].contains(0) || fields[i].contains(0)) {
                return 0
            }
        }
        if ( fields[size-1].contains(0)) {
            return 0
        }
        var count = 0
        for arr in fields {
            for i in 0..<size {
                if ( arr[i] == id) {
                    count += 1
                }
            }
        }
        for arr in fields_small {
            for i in 0..<size-1 {
                if ( arr[i] == id) {
                    count += 1
                }
            }
        }

        if (count > ( size * size + (size - 1)*(size - 1) )/2) {
            return 1
        } else {
            return -1
        }
    }

    public func isOccupiedDash(i: Int, j: Int) -> Int {
        let coord = getFirstFreeSpace()
        if ( coord == (0,0) ) {
            return 0
        }
        return dash[i][j]
    }
}


class Game {
    private var userId: Int = 0;
    private var matrix: Matrix?
    public var move: Bool = true
    public var size: Int {
        get { return matrix != nil ? matrix!.size : 0 }
    }

    init(size: Int) {
        matrix = Matrix(size: size)
    }

    public func move(i: Int, j: Int, id: Int) -> String? {
        if ( matrix == nil) { return nil }
//        if ( move ) {
            let result = self.matrix!.putDash(i: i, j: j, id: id)
            let array = result.components(separatedBy: "^")
            if ( array[0] == "" ) {
                move = !move
            }
            return result
        //}
        //return nil
    }

    public func isOccupied(i: Int, j: Int) -> Bool {
        return matrix!.isOccupiedDash(i: i, j: j) == 1
    }


    public func makeBestMove() -> String? {
        var i = 0
        var j = 0
        var count = 0
        repeat{
            i = Int(arc4random_uniform(UInt32(size*2 - 2))) + 1
            j = Int(arc4random_uniform(UInt32(size*2 - 2))) + 1
            count += 1
            if ( count > 100) {
                (i,j) = matrix!.getFirstFreeSpace()
            }
        }
        while ( matrix?.isOccupiedDash(i: i, j: j) != 0)
        return (move(i: i, j: j, id: 2) ?? "^") + "^\(i):\(j)"
    }
}
