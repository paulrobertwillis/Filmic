//
//  StoryboardInstantiable.swift
//  MovieApp
//
//  Created by Paul on 02/09/2022.
//

import UIKit

public protocol StoryboardInstantiable: NSObjectProtocol {
    associatedtype T
    static var defaultFileName: String { get }
    static func instantiateViewController(_ bundle: Bundle?) -> T
}

public extension StoryboardInstantiable where Self: UIViewController {
    static var defaultFileName: String {
        NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }
    
    static func instantiateViewController(_ bundle: Bundle? = nil) -> Self {
        let fileName = self.defaultFileName
        let storyboard = UIStoryboard(name: fileName, bundle: bundle)
        
        guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Cannot instantiate initial view controller, \(Self.self), from storyboard with name \(fileName)")
        }
        
        return viewController
    }
}
