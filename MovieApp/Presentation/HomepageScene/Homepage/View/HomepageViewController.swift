//
//  HomepageViewController.swift
//  MovieApp
//
//  Created by Paul on 02/09/2022.
//

import UIKit

class HomepageViewController: UIViewController, StoryboardInstantiable {
    
    // MARK: - Private Properties
    
    private var viewModel: HomepageViewModelProtocol!
    
    // MARK: - Lifecycle
    
    static func create(with viewModel: HomepageViewModelProtocol) -> HomepageViewController {
        let view = HomepageViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
}
