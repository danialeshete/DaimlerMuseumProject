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
            navigationController
        }
    }
    
    private var navigationController = UINavigationController()
    
    var delegate: ClientCoordinatorDelegate?
    
    init() {
        let clientView = createClientViewController()
        navigationController.setViewControllers([clientView], animated: false)
    }
    
    private func createClientViewController() -> UIViewController {
        let clientViewController = ClientViewController.makeFromStoryboard()
        let clientPresenter = ClientPresenter()
        
        clientViewController.presenter = clientPresenter
        clientPresenter.delegate = self
        
        return clientViewController
    }
    
    private func showGameViewController() {
        let gameView = GameViewController.makeFromStoryboard()
        
        DispatchQueue.main.async {
            self.navigationController.setViewControllers([gameView], animated: false)
        }
    }
    
    private func showARViewController() {
        let arView = ARViewController.makeFromStoryboard()
        
        DispatchQueue.main.async {
            self.navigationController.setViewControllers([arView], animated: false)
        }
    }
    
    private func showAvatarViewController() {
        let avatarView = AvatarViewController.makeFromStoryboard()
        
        DispatchQueue.main.async {
            self.navigationController.setViewControllers([avatarView], animated: false)
        }
    }
}

extension ClientCoordinator: ClientCoordinatorProtocol {
    
    public func handle(event: Event) {
        switch event {
        case .showGame:
            showGameViewController()
        case .read(let message):
            print("read Message \(message)")
        case .showARCamera:
            showARViewController()
        case .showAvatar:
            showAvatarViewController()
        }
    }
    
}

extension ClientCoordinator: ClientPresenterDelegate {
    
}
