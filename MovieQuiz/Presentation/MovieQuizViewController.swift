import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount:Int = 10
    
    private var questionFactory:QuestionFactoryProtocol?
    private var currentQuestion:QuizQuestion?
    private var alertPresenter:AlertPresenterProtocol?
    private var statisticService:StatisticService?
    
    
    
    
    override var preferredStatusBarStyle:UIStatusBarStyle {
        return.lightContent
    }
    
    @IBAction private func noBottonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    
    
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var counterLabel: UILabel!
    
    
    
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named:model.image) ?? UIImage(),
            question: model.text,
            questionNumber:"\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        imageView.layer.borderWidth = 0
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.layer.cornerRadius = 20
    }
    
    private func show(quiz model:AlertModel) {
        alertPresenter?.showAlert(model:model)
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self]_ in
            guard let self = self else {return}
            
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    private func showNextQuestionOrResults() {
        
        imageView.layer.borderWidth = 0
        
        if currentQuestionIndex == questionsAmount - 1 {
            showFinalResults()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    
    
    
    private func showAnswerResult(isCorrect: Bool) {
        
        if isCorrect {
            correctAnswers += 1
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            imageView.layer.cornerRadius = 20
        }
        else {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypRed.cgColor
            imageView.layer.cornerRadius = 20
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self]
            in guard let self = self else {return}
            self.showNextQuestionOrResults()
        }
    }
    
    
    // MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        
        statisticService = StatisticServiceImplementation(userDefaults: UserDefaults.standard,
                                                          decoder: JSONDecoder(),
                                                          encoder: JSONEncoder())

        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(delegate: self)
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    private func showFinalResults() {
        statisticService?.store(correct: correctAnswers, total: questionsAmount)
        
        guard let statisticService = statisticService else {
            return ()
        }
        guard let bestGame = statisticService.bestGame else {
            return()
        }
        
        let text = "Ваш результат: \(correctAnswers)/10 Количество сыгранных раундов: \(statisticService.gamesCount) Рекорд: \(bestGame.correct)/10 (\(Date())) Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))% "
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: text,
            buttonText: "Сыграть ещё раз") { [weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            }
        self.alertPresenter?.showAlert(model: alertModel)
    }
    
    
}






