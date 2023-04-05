//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Olya on 28.03.2023.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}
