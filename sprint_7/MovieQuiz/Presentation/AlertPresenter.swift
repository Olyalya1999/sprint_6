//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Olya on 28.03.2023.
//

import Foundation
import UIKit

final class AlertPresenter:AlertPresenterProtocol
{
    private weak var delegate: AlertPresenterDelegate?
    
    
    init(delegate: AlertPresenterDelegate?)
    {
        self.delegate = delegate
    }
    
    func showAlert(model: AlertModel) {

        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }
        
        alert.view.accessibilityIdentifier = "Game results"
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
}
