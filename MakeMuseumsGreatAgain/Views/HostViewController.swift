//
//  HostViewController.swift
//  MakeMuseumsGreatAgain
//
//  Created by Niklas Schildhauer on 19.11.21.
//

import UIKit

protocol HostPresenterDelegate { }

protocol HostPresenting {
    var view: HostViewing? { get set }
    var delegate: HostPresenterDelegate? { get set }
    
    func viewDidLoad()
    func showGame()
    func showARCamera()
    func showAvatar()
}

protocol HostViewing: AnyObject {
    var presenter: HostPresenting! { get set }
    
}

class HostViewController: UIViewController {
    
    var presenter: HostPresenting! {
        didSet {
            presenter.view = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    @IBAction func showGame(_ sender: Any) {
        presenter.showGame()
    }
    
    
    @IBAction func showARCamera(_ sender: Any) {
        presenter.showARCamera()
    }
    
    @IBAction func showAvatar(_ sender: Any) {
        presenter.showAvatar()
    }
}

extension HostViewController: StoryboardInitializable { }

extension HostViewController: HostViewing {
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
    
    func showGame() {
        let event = Event.showGame
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
}
