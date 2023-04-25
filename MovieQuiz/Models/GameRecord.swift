//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Olya on 24.04.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}
    
extension GameRecord: Comparable{
    
    private var accurasy: Double {
        guard total != 0 else {
            return 0
        }
        return Double(correct) / Double(total)
    }
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.accurasy < rhs.accurasy
    }
}