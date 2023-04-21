//
//  BestGame.swift
//  MovieQuiz
//
//  Created by Olya on 28.03.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total:Int
    let date: Date
}
extension GameRecord: Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct < rhs.correct
    }
}
