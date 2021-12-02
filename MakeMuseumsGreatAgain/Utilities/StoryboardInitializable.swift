//
//  StoryboardInitializable.swift
//  iMeister
//
//  Created by Joe Shanley on 07/11/2018.
//  Copyright © 2018 Porsche AG. All rights reserved.
//

import Foundation
import UIKit

public protocol Storyboard {
    var filename: String { get }
    
    var bundle: Bundle? { get }
}

public extension Storyboard {
    
    // Can override this if we support multiple bundles
    var bundle: Bundle? {
        return nil
    }
}

public struct MainStoryboard: Storyboard {
    public var filename: String = "Main"
}

public protocol StoryboardInitializable {
    static var storyboard: Storyboard { get }
    
    static func makeFromStoryboard() -> Self
    
    func embedInNavigationController() -> UINavigationController
}

public extension StoryboardInitializable where Self : UIViewController {
    static var storyboard: Storyboard {
        MainStoryboard()
    }

    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    static func makeFromStoryboard() -> Self {
        let storyboardFile = UIStoryboard(name: storyboard.filename, bundle: storyboard.bundle)

        return storyboardFile.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
    
    func embedInNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
}
