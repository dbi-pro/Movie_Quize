import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    private var currentQuestionIndex = 0
    private var correctAnswersCount = 0
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpUIFonts()
        let currentQuestion = questions[currentQuestionIndex]
        let viewModel = convertToViewModel(currentQuestion)
        show(viewModel: viewModel)
    }
    
    private func setUpUIFonts() {
        
        let neadedFont = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = neadedFont
        counterLabel.font = neadedFont
        textLabel.font = neadedFont
        noButton.titleLabel?.font = neadedFont
        yesButton.titleLabel?.font = neadedFont
    }
    
    private func convertToViewModel(_ question: QuizQuestion) -> QuizStepViewModel {
        
        let currentImage = UIImage(named: question.image) ?? UIImage()
        return QuizStepViewModel(image: currentImage, question: question.text, questionNumber: "\(currentQuestionIndex+1)/\(questions.count)")
    }
    
    private func show(viewModel: QuizStepViewModel) {
        
        imageView.image = viewModel.image
        counterLabel.text = viewModel.questionNumber
        textLabel.text = viewModel.question
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswersCount = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convertToViewModel(firstQuestion)
            self.show(viewModel: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showNextQuestionOrResults() {
        
        imageView.layer.borderColor = nil
        imageView.layer.borderWidth = 0
        
        if currentQuestionIndex == questions.count - 1 {
            
            let text = "Ваш результат: \(correctAnswersCount)/\(questions.count)"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        }
        else {
            currentQuestionIndex += 1
            let currentQuestion = questions[currentQuestionIndex]
            let viewModel = convertToViewModel(currentQuestion)
            show(viewModel: viewModel)
        }
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        if isCorrect { correctAnswersCount += 1 }
        
        let colorOfResult: UIColor = isCorrect ? .ypGreen : .ypRed
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = colorOfResult.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
        let currentquestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: currentquestion.correctAnswer == false)
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        let currentquestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: currentquestion.correctAnswer == true)
    }    
}
