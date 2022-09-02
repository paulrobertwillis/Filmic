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
    
    private var recommendedMoviesCollectionViewController: RecommendedMoviesCollectionViewController?
    
    // MARK: - Lifecycle
    
    static func create(with viewModel: HomepageViewModelProtocol) -> HomepageViewController {
        let view = HomepageViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: RecommendedMoviesCollectionViewController.self),
           let destinationViewController = segue.destination as? RecommendedMoviesCollectionViewController {
            self.recommendedMoviesCollectionViewController = destinationViewController
        }
    }
}
