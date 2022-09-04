//
//  HomepageViewModel.swift
//  MovieApp
//
//  Created by Paul on 02/09/2022.
//

import Foundation

struct HomepageViewModelActions {
    
}

protocol HomepageViewModelProtocol {
    
}

class HomepageViewModel: HomepageViewModelProtocol {
    
    // MARK: - Private Properties
    
    private let actions: HomepageViewModelActions
    
    // MARK: - Init
    
    init(actions: HomepageViewModelActions) {
        self.actions = actions
    }
    
    
}
