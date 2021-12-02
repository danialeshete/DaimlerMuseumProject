//
//  ViewController.swift
//  MakeMuseumsGreatAgain
//
//  Created by Niklas Schildhauer on 19.11.21.
//

import UIKit

protocol MainPresenterDelegate { }

protocol MainPresenting {
    var view: MainViewing? { get set }
    var delegate: MainPresenterDelegate? { get set }
    
    func viewDidLoad()
    func join()
    func host()
}

protocol MainViewing: AnyObject {
    var presenter: MainPresenting! { get set }

    func show(hostScreen: UIViewController)
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var hostButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    
    var presenter: MainPresenting! {
        didSet {
            presenter?.view = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapJoin(_ sender: Any) {
        presenter?.join()
    }
    
    @IBAction func didTapHost(_ sender: Any) {
        presenter?.host()
    }
    
}

extension MainViewController: StoryboardInitializable { }

extension MainViewController: MainViewing {
    
    func show(hostScreen: UIViewController) {
        present(hostScreen, animated: true)
    }
}

class MainPresenter: MainPresenting {
    var delegate: MainPresenterDelegate?
    
    let connectionManager: ConnectionManager
    weak var view: MainViewing?
    
    init(connectionManager: ConnectionManager) {
        self.connectionManager = connectionManager
    }
    
    func viewDidLoad() {
        
    }

    func join() {
        connectionManager.join()
    }
    
    func host() {
        connectionManager.host()
    }

}



