//
//  QuestionGameViewController.swift
//  MakeMuseumsGreatAgain
//
//  Created by Niklas Schildhauer on 15.12.21.
//

import UIKit

protocol QuestionGameViewing: AnyObject {
    var presenter: QuestionGamePresenting! { get set }
    
    func display(text: String)
    func display(background: UIImage)
    func display(promptText: String)
    func showStars()
}

protocol QuestionGamePresenting {
    var view: QuestionGameViewing? { get set }
    var numberOfAnswers: Int { get }
    
    func configure(answer: QuestionAnswerViewing, at index: Int)
    func didTapAnswer(at index: Int, for cell: QuestionAnswerCollectionView)
    func viewDidLoad()
}

protocol QuestionAnswerViewing {
    func display(text: String)
}

protocol QuestionGameDelegate {
    func didEarn(points: Int)
}

class QuestionGamePresenter: QuestionGamePresenting {

    weak var view: QuestionGameViewing?
    
    var delegate: QuestionGameDelegate?
    
    private let question: Question
    private var wrongAnswers: Int = 1
    
    var numberOfAnswers: Int {
        question.answers.count
    }
    
    init(question: Question) {
        self.question = question
    }
    
    func viewDidLoad() {
        view?.display(text: question.text)
        if let imageName = question.imageName,
            let image = UIImage(named: imageName) {
            view?.display(background: image)
        }
    }
    
    func configure(answer: QuestionAnswerViewing, at index: Int) {
        answer.display(text: question.answers[index].text)
    }

    
    func didTapAnswer(at index: Int, for cell: QuestionAnswerCollectionView) {
        if question.answers[index].isTrue {
            cell.background.backgroundColor = UIColor(red: 48, green: 122, blue: 82, alpha: 1)
            view?.showStars()
            view?.display(promptText: "Glückwunsch! Du bekommst \(100/wrongAnswers) Sterne 🚀")
            delegate?.didEarn(points: 100/wrongAnswers)
        } else {
            cell.background.backgroundColor = UIColor.init(red: 128, green: 43, blue: 43, alpha: 1)
            wrongAnswers = wrongAnswers + 1
        }
    }
    
}

class QuestionGameViewController: UIViewController {
    
    var presenter: QuestionGamePresenting! {
        didSet {
            presenter.view = self
        }
    }
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var textBackground: UIView!
    @IBOutlet weak var promptText: UILabel!
    @IBOutlet weak var promptTextWrapper: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var confettiView: SwiftConfettiView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        text.numberOfLines = 0
        textBackground.blurBackground(behind: text)
        
        navigationController?.navigationBar.isHidden = true
        
        let confettiView = SwiftConfettiView(frame: self.view.bounds)
        self.view.addSubview(confettiView)
        self.confettiView = confettiView
        confettiView.isHidden = true
        
        presenter.viewDidLoad()
    }
}

extension QuestionGameViewController: StoryboardInitializable { }

extension QuestionGameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfAnswers
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionAnswerCollectionView", for: indexPath) as! QuestionAnswerCollectionView
    
        cell.blurBackground(behind: cell.background)
        
        
        presenter.configure(answer: cell, at: indexPath.row)
                        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! QuestionAnswerCollectionView
        
        presenter.didTapAnswer(at: indexPath.row, for: cell)
        
    }
}

// MARK: - Collection View Flow Layout Delegate
extension QuestionGameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = 15.0
        
        let availableWidth = collectionView.frame.width
        let widthPerItem = availableWidth / 2 - padding
        
        let availableHeight = collectionView.frame.height
        let heightPerItem = availableHeight / 2 - padding
        
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 30
    }
}


extension QuestionGameViewController: QuestionGameViewing {
    func showStars() {
        confettiView?.isHidden = false
        confettiView?.startConfetti()
    }
    
    func display(background: UIImage) {
        backgroundImage.image = background
    }
    
    func display(text: String) {
        self.text.text = text
    }
    
    func display(promptText: String) {
        self.promptText.text = promptText
        self.promptTextWrapper.isHidden = false
    }
}

class QuestionAnswerCollectionView: UICollectionViewCell, QuestionAnswerViewing {
    
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var background: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func display(text: String) {
        self.text.text = text
    }
}
