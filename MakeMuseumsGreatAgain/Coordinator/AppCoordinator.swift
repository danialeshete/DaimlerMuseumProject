//
//  Coordinator.swift
//  MakeMuseumsGreatAgain
//
//  Created by Niklas Schildhauer on 19.11.21.
//

import Foundation
import UIKit
import MultipeerConnectivity

protocol Coordinator {
    var rootViewController: UIViewController { get }
}

class AppCoordinator: Coordinator {
    var rootViewController: UIViewController = UIViewController() {
        didSet {
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
        }
    }
    
    private let window: UIWindow
    private var connectionManager: ConnectionManager = ConnectionManager()
    private var clientCoordinator: ClientCoordinator = ClientCoordinator()
    private var hostPresenter: HostPresenting?

    
    init(window: UIWindow) {
        self.window = window
        
        connectionManager.delegate = self
        clientCoordinator.delegate = self
        
        showMainViewController()
    }
        
    private func showMainViewController() {
        let mainView = MainViewController.makeFromStoryboard()
        let mainPresenter = MainPresenter(connectionManager: connectionManager)
        mainView.presenter = mainPresenter
        mainPresenter.delegate = self
        
        rootViewController = mainView
    }
    
    private func showHostViewController() {
        let hostView = HostViewController.makeFromStoryboard()
        let hostPresenter = HostPresenter(connectionManager: connectionManager)
        hostView.presenter = hostPresenter
        hostPresenter.delegate = self
        hostView.isModalInPresentation = true
        DispatchQueue.main.async {
            self.rootViewController.present(hostView, animated: true)
        }
        self.hostPresenter = hostPresenter
    }
    
    private func showClientCoordinator() {        
        DispatchQueue.main.async {
            self.rootViewController.present(self.clientCoordinator.rootViewController, animated: true)
        }
    }
}

extension AppCoordinator: ClientCoordinatorDelegate {
    
}

extension AppCoordinator: HostPresenterDelegate {
    
}

extension AppCoordinator: MainPresenterDelegate {

}

extension AppCoordinator: ConnectionManagerDelegate {
    func clientsHaveChanged(clients: [MCPeerID]) {
        hostPresenter?.clientsHaveChanged(clients: clients)
    }
    
    func didRecieveClient(event: Event, in: ConnectionManager) {
        clientCoordinator.handle(event: event)
    }
    
    func didJoinSession(in: ConnectionManager) {
        showClientCoordinator()
    }
    
    func didHostSession(in: ConnectionManager) {
        showHostViewController()
    }
}
