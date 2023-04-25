//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Olya on 28.03.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
