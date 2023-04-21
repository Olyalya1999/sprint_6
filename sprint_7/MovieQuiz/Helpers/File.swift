//
//  File.swift
//  MovieQuiz
//
//  Created by Olya on 27.03.2023.
//

import Foundation

subscript(index: Int) -> Int {
    get {
        // Возвращаем соответствующее значение
    }
    set(newValue) {
        // Устанавливаем подходящее значение
    }
}

extension Array { subscript(safe index: Index) -> Element? { indices ~= index ? self[index] : nil }}
