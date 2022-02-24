//
//  ClientCoordinator.swift
//  MakeMuseumsGreatAgain
//
//  Created by Niklas Schildhauer on 23.11.21.
//

import Foundation
import UIKit

protocol ClientCoordinatorDelegate {
    
}

protocol ClientCoordinatorProtocol {
    var delegate: ClientCoordinatorDelegate? { get set }
    
    func handle(event: Event)
}

class ClientCoordinator: Coordinator {
    var rootViewController: UIViewController {
        get {
            clientView
        }
    }
    
    private var clientView: ClientViewController
    private var gameCoordinator: GameCoordinator = GameCoordinator()
    private var stars: Int = 0 {
        didSet {
            clientView.display(points: stars)
        }
    }
    private var blocked = false
    
    var delegate: ClientCoordinatorDelegate?
    
    init() {
        let clientViewController = ClientViewController.makeFromStoryboard()
        clientView = clientViewController
        let clientPresenter = ClientPresenter()
        
        clientView.modalPresentationStyle = .overFullScreen
        
        clientViewController.presenter = clientPresenter

        clientPresenter.delegate = self
    }
    
    private func showGameViewController(for gameEvent: GameEvent) {
        self.clientView.hideViewController()

        let gameView = self.gameCoordinator.rootViewController
        gameCoordinator.handle(gameEvent: gameEvent)
        gameCoordinator.delegate = self
        
        self.clientView.show(viewController: gameView)
    }
    
    private func showStarViewController(with stars: Int) {
        self.clientView.hideViewController()


        let starView = StarsViewController.makeFromStoryboard()
        self.stars = self.stars + stars
        starView.stars = self.stars
        
        starView.modalPresentationStyle = .overFullScreen
        
        clientView.show(viewController: starView)
    }
    
    private func showARViewController() {
        self.clientView.hideViewController()

        let arView = ARRealityKitViewController.makeFromStoryboard()
        self.clientView.show(viewController: arView)
    }
    
    private func showAvatarViewController() {
        self.clientView.hideViewController()
    }
    
    private func reloadViews()  {
        self.clientView.reload()
    }
}

extension ClientCoordinator: ClientCoordinatorProtocol {
    
    public func handle(event: Event) {
        guard !blocked else { return }
        blocked = true
        DispatchQueue.main.async {
            switch event {
            case .showGame(let gameEvent):
                self.showGameViewController(for: gameEvent)
            case .read(let message):
                print("read Message \(message)")
            case .showARCamera:
                self.showARViewController()
            case .showAvatar:
                self.showAvatarViewController()
            case .reload:
                self.reloadViews()
            case .dismiss:
                self.rootViewController.dismiss(animated: true)
            case .scroe(stars: let stars):
                self.showStarViewController(with: stars)
            }
            self.blocked = false
        }
    }
}

extension ClientCoordinator: ClientPresenterDelegate {
    
}

extension ClientCoordinator: GameCoordinatorDelegate {
    func didEarn(points: Int) {
        self.stars = self.stars + points
    }
}
