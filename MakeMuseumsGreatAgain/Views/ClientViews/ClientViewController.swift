//
//  ClientViewController.swift
//  MakeMuseumsGreatAgain
//
//  Created by Niklas Schildhauer on 19.11.21.
//

import UIKit

protocol ClientPresenterDelegate {
    
}

protocol ClientPresenting {
    var view: ClientViewing? { get set }
    var delegate: ClientPresenterDelegate? { get set }
    
    func viewDidLoad()
}

protocol ClientViewing: AnyObject {
    var presenter: ClientPresenting! { get set }
}

class ClientViewController: UIViewController {
    
    var presenter: ClientPresenting! {
        didSet {
            presenter.view = self
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ClientViewController: StoryboardInitializable { }

extension ClientViewController: ClientViewing {
}


class ClientPresenter: ClientPresenting {
    var delegate: ClientPresenterDelegate?
    
    weak var view: ClientViewing?
    
    func viewDidLoad() {
        
    }

}
