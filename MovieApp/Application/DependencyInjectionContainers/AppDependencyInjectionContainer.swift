//
//  AppDependencyInjectionContainer.swift
//  MovieApp
//
//  Created by Paul on 02/09/2022.
//

import Foundation

protocol AppDependencyInjectionContainerProtocol {
    var genresDataTransferService: DataTransferService<GenresResponseDTO> { get }
}

class AppDependencyInjectionContainer: AppDependencyInjectionContainerProtocol {
    
    // MARK: - Network
    
    lazy var genresDataTransferService: DataTransferService<GenresResponseDTO> = {
        let networkRequestPerformer = NetworkRequestPerformer()
        let output = ConsoleLogOutput()
        let printer = NetworkLogPrinter(output: output)
        let logger = NetworkLogger(printer: printer)
        let networkService = NetworkService(networkRequestPerformer: networkRequestPerformer, logger: logger)
        
        return DataTransferService<GenresResponseDTO>(networkService: networkService)
    }()
    
    // MARK: - DependencyInjectionContainers of Scenes
    
    
}