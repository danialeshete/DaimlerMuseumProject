//
//  AvatarViewController.swift
//  MakeMuseumsGreatAgain
//
//  Created by Niklas Schildhauer on 25.11.21.
//

import UIKit
import AVFoundation
import WebKit
import ProgressWebViewController
import SafariServices

protocol AvatarViewing: AnyObject {
    var presenter: AvatarPresenting? { get set }
    
    func display(url: URL)
    func reload()
}

protocol AvatarPresenting {
    var view: AvatarViewing? { get set }
    func viewDidLoad()
}

class AvatarPresenter: AvatarPresenting {
    weak var view: AvatarViewing?
    var player: AVPlayer?
    
    func viewDidLoad() {
        view?.display(url: createURLRequest())
    }
    
    private func createURLRequest() -> URL {
        return URL(string: "https://facetime.apple.com/join#v=1&p=RrSPfl2DEeyH+gJCBYOMLA&k=XF9T4oqHCEEe41Qs0UKV1RnX-NYAC_uuOzhAzUu1X1E")!
        //return URL(string:"https://obs.ninja/?view=35aGL4n")!
    }
}

class AvatarViewController: UIViewController {
    
    var presenter: AvatarPresenting? {
        didSet {
            presenter?.view = self
        }
    }
    @IBOutlet weak var videoContainer: UIView!
    let webViewController = ProgressWebViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        webViewController.delegate = self
        add(childViewController: webViewController, insets: .zero)
    }
}

extension AvatarViewController: ProgressWebViewControllerDelegate {
    func progressWebViewController(_ controller: ProgressWebViewController, didFinish url: URL) {
        //let thisInner = "this.document.getElementById('bigPlayButton').click(); this.document.body.style.backgroundColor = \"#000000\"";
        //controller.evaluateJavaScript(thisInner, completionHandler: nil)
    }
    
}

extension AvatarViewController: StoryboardInitializable { }

extension AvatarViewController: AvatarViewing {
    func reload() {
        //let thisInner = "this.document.getElementsByClassName('tile')[0].pause(); this.document.getElementsByClassName('tile')[0].load(); this.document.getElementsByClassName('tile')[0].play();";
        //webViewController.evaluateJavaScript(thisInner, completionHandler: nil)
        //webViewController.reload()
    }
    
    func display(url: URL) {
        webViewController.load(url)
    }
}

