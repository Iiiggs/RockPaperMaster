//: Playground - noun: a place where people can play

import Cocoa

let log_game_result = false
let log_battle_result = true

class BattleScore : NSObject {
    var wins:Int = 0
    var losses:Int = 0
    var ties:Int = 0
    
    override var description: String {
        return "\(wins)-\(losses)-\(ties)"
    }
}

class BattleScorecard : NSObject {
    let battleScores:[Player: BattleScore]! = [:]
    
    init(players:[Player]) {
        
        for p in players {
            battleScores[p] = BattleScore()
        }
    }
    
    func recordWin(winner:Player, losser:Player){
        self.battleScores[winner]!.wins += 1
        self.battleScores[losser]!.losses += 1
    }
    
    func recordTie(player1:Player, player2:Player){
    
    }
    
    override var description : String {
        return battleScores.description
    }
}

class Battle{
    // multiple players
    let players:[Player]
    let scorecard:BattleScorecard
    
    init(players:[Player]) {
        self.players = players
        self.scorecard = BattleScorecard(players: players)
    }
    
    func play(){
        for p in self.players {
            // for each player other then self, battle
            for o in self.players.filter({ (pl) -> Bool in return pl != p }){
                let g = Game(player1: p, player2: o)
                let gameScore = g.play()
                
                if gameScore.winner != nil {
                    self.scorecard.recordWin(winner: gameScore.winner!, losser: gameScore.loser!)
                } else {
                    self.scorecard.recordTie(player1: p, player2: o)
                }
            }
        }
        
        if log_battle_result {
            print("\(self.scorecard)")
        }
    }
    
    // each plays against the others
    // rankings after battle
}

class Player : NSObject {
    let name:String!
    init(name:String) {
        self.name = name
    }
    
    func move(opponentMove:Move?) -> Move {
//        if let move = opponentMove {
//            return move
//        }
        
        return Move.randomMove()
    }
    
    override var description :  String{
        return self.name
    }
}

class GameScore {
    var player1 = 0
    var player2 = 0
    var winner : Player?
    var loser : Player?
}

class Game {
    // {
    //  "player1":4,
    //  "player2":3,
    //  "winner":"player1"
    // }
    let score:GameScore!
    let player1:Player!
    let player2:Player!
    init(player1:Player, player2:Player) {
        self.player1 = player1
        self.player2 = player2
        self.score = GameScore()
    }
    
    
    // players
    // recent moves
    
    // loop
    func play() -> GameScore{
        var move1 : Move?
        var move2 : Move?
        let start = NSDate()
        
        for _ in 0...1000 {
            move1 = player1.move(opponentMove: move2)
            move2 = player2.move(opponentMove: move1)
            
            let result = get_throw_results(move1: move1!, move2: move2!)
            switch result {
            case .Win:
                self.score.player1 += 1
            case .Loss:
                self.score.player2 += 1
            default: break
            }
            
//            print("\(move1!) X \(move2!) = \(result)")
        }
        
//        winner is higest score
        if self.score.player2 > self.score.player1 {
            self.score.winner = self.player2
            self.score.loser = self.player1
        } else if self.score.player1 > self.score.player2 {
            self.score.winner = self.player1
            self.score.loser = self.player2
        }
//
        if let winner = self.score.winner {
            let end = NSDate()
            let duration : Double = end.timeIntervalSince(start as Date)
            
            if log_game_result {
                print("\(winner) wins in \(duration) seconds")
            }
            
        }
        
        return self.score
    }
}

enum Move : UInt32 {
    case Rock
    case Paper
    case Scissors
    case Dynomyte
    case Water
    
    static func randomMove() -> Move {
        // pick and return a new value
        let rand = arc4random_uniform(5)
        return Move(rawValue: rand)!
    }
}

enum ThrowResult {
    case Win
    case Loss
    case Tie
}

// last move
func get_player1_move() -> Move {
    return Move.randomMove()
}

func get_player2_move() -> Move {
    return .Rock
}

func get_throw_results(move1:Move, move2:Move) -> ThrowResult{
    if move1 == move2 {
        return .Tie
    }
    
    switch move1 {
    // player 1 throws rock
    case .Rock:
        switch move2 {
        case .Rock: return .Tie
        case .Scissors: return .Win
        case .Paper: return .Loss
        case .Dynomyte: return .Loss
        case .Water: return .Win
        }
    // player 1 throws paper
    case .Paper:
        switch move2 {
        case .Paper: return .Tie
        case .Scissors: return .Loss
        case .Rock: return .Win
        case .Dynomyte: return .Loss
        case .Water: return .Win
        }
    // player 1 throws scissors
    case .Scissors:
        switch move2 {
        case .Scissors: return .Tie
        case .Paper: return .Win
        case .Rock: return .Loss
        case .Dynomyte: return .Loss
        case .Water: return .Win
        }
    // player 1 throws dynomyte
    case .Dynomyte:
        switch move2 {
        case .Dynomyte: return .Tie
        case .Scissors: return .Win
        case .Rock: return .Win
        case .Paper: return .Win
        case .Water: return .Loss
        }
    // player 1 throws water
    case .Water:
        switch move2 {
        case .Water: return .Tie
        case .Scissors: return .Loss
        case .Rock: return .Loss
        case .Paper: return .Loss
        case .Dynomyte: return .Win
        }
    }
}

let player1 = Player(name:"Player 1")
let player2 = Player(name:"Player 2")
let player3 = Player(name:"Player 3")
let player4 = Player(name:"Player 4")
let player5 = Player(name:"Player 5")
//let battle = Battle(players: [player1, player2])
let battle = Battle(players: [player1, player2, player3, player4, player5])
battle.play()