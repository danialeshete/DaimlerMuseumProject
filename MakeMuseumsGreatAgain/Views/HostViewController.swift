//
//  HostViewController.swift
//  MakeMuseumsGreatAgain
//
//  Created by Niklas Schildhauer on 19.11.21.
//

import UIKit
import MultipeerConnectivity

protocol HostPresenterDelegate { }

protocol HostPresenting {
    var view: HostViewing? { get set }
    var delegate: HostPresenterDelegate? { get set }
    var numberOfQuestions: Int { get }
    
    func nameOfListItem(at Index: Int) -> String
    func didTapListItem(at Index: Int)
    func clientsHaveChanged(clients: [MCPeerID])
    func viewDidLoad()
    func showARCamera()
    func showAvatar()
    func reload()
    func dismiss()
    func add100Points()
}

protocol HostViewing: AnyObject {
    var presenter: HostPresenting! { get set }
    
    func display(peersText: String)
    
}

class HostViewController: UIViewController {
    
    var presenter: HostPresenting! {
        didSet {
            presenter.view = self
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var peersLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(HostTableViewCell.self, forCellReuseIdentifier: "hostCell")
        presenter.viewDidLoad()
    }
    
    @IBAction func reload(_ sender: Any) {
        presenter.reload()
    }
        
    @IBAction func showARCamera(_ sender: Any) {
        presenter.showARCamera()
    }
    
    @IBAction func add100Points(_ sender: Any) {
        presenter.add100Points()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        presenter.dismiss()
        dismiss(animated: true)
    }
        
    @IBAction func showAvatar(_ sender: Any) {
        presenter.showAvatar()
    }
}

extension HostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfQuestions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "hostCell") as! HostTableViewCell
        
        cell.titleLabel.text = presenter.nameOfListItem(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapListItem(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HostViewController: StoryboardInitializable { }

extension HostViewController: HostViewing {
    func display(peersText: String) {
        DispatchQueue.main.async {
            self.peersLabel.text = peersText
        }
    }
}

class HostTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        internalInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        internalInit()
    }
    
    func internalInit() {
        addSubview(titleLabel)
        titleLabel.anchorToAllEdgesOfSuperview(insets: .init(top: 12, left: 16, bottom: 12, right: 16))
    }
}

class HostPresenter: HostPresenting {

    var delegate: HostPresenterDelegate?
    
    weak var view: HostViewing?
    
    private let connectionManager: ConnectionManager
    
    init(connectionManager: ConnectionManager) {
        self.connectionManager = connectionManager
    }

    func viewDidLoad() {
        
    }
    
    func dismiss() {
        connectionManager.send(.dismiss)
    }
    
    var numberOfQuestions: Int {
        questions.count
    }
    
    func nameOfListItem(at Index: Int) -> String {
        questions[Index].text
    }
    
    func didTapListItem(at Index: Int) {
        let question = questions[Index]
        let event = Event.showGame(gameEvent: .question(question))
        connectionManager.send(event)
    }
    
    func showARCamera() {
        let event = Event.showARCamera
        connectionManager.send(event)
    }
    
    func showAvatar() {
        let event = Event.showAvatar
        connectionManager.send(event)
    }
    
    func reload() {
        let event = Event.reload
        connectionManager.send(event)
    }
    
    func clientsHaveChanged(clients: [MCPeerID]) {
        view?.display(peersText: "Aktuell sind \(clients.count) verbunden.")
    }
    
    func add100Points() {
        let event = Event.scroe(stars: 100)
        connectionManager.send(event)
    }

    private let questions: [Question] = [
        Question(text: "Wie viele Exemplare der Standuhr kannst du sehen?",
                 answers: [
                    Answer(text: "Nur das Eine", isTrue: false),
                    Answer(text: "Zwei", isTrue: false),
                    Answer(text: "Ganz Viele", isTrue: true),
                    Answer(text: "Keines", isTrue: false)
                 ], imageName: "01"),
        Question(text: "Wann war der Zusammenschluss von Carl Benz und Gottfried Daimler?",
                 answers: [
                    Answer(text: "1890", isTrue: false),
                    Answer(text: "1898", isTrue: false),
                    Answer(text: "1900", isTrue: false),
                    Answer(text: "Welcher Zusammenschluss?", isTrue: true)
                 ], imageName: "02"),
        Question(text: "Kannst du mir sagen wann die Unternehmen von Benz und Daimler gegründet wurden?",
                 answers: [
                    Answer(text: "Karl Benz: 1880 & Gottfried Daimler 1990", isTrue: false),
                    Answer(text: "Karl Benz: 1883 & Gottfried Daimler 1890", isTrue: false),
                    Answer(text: "Karl Benz: 1884 & Gottfried Daimler 1890", isTrue: true),
                    Answer(text: "Karl Benz: 1883 & Gottfried Daimler 1793", isTrue: false)
                 ], imageName: nil),
        Question(text: "Weißt du denn, woher der Markenname Mercedes kommt? Wieso heißt die Marke nicht Daimler-Benz? ",
                 answers: [
                    Answer(text: "Name der Tochter von Gottfried Daimler", isTrue: false),
                    Answer(text: "Mercedes ist schwäbisch für “mehr sehen”", isTrue: false),
                    Answer(text: "Großkunde von DMG fuhr unter dem Namen Rennen", isTrue: true),
                    Answer(text: "Weil es einfach ein schöner Name ist.", isTrue: false)
                 ], imageName: "04"),
        Question(text: "Erkennst du, was genau an dem Automobil so gefährlich war?",
                 answers: [
                    Answer(text: "Hohe Schwerpunkt", isTrue: false),
                    Answer(text: "Zu schwergängige Lenkung", isTrue: false),
                    Answer(text: "Radstand zu klein", isTrue: false),
                    Answer(text: "Eigentlich alles", isTrue: true)
                 ], imageName: "05"),
        
        
    ]
}
