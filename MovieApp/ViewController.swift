//
//  ViewController.swift
//  MovieApp
//
//  Created by Paul on 12/06/2022.
//

import UIKit

class ViewController: UIViewController {
    
    var useCase: GetMovieGenresUseCase?

    override func viewDidLoad() {
        super.viewDidLoad()

        let networkRequestPerformer = NetworkRequestPerformer()
        let output = ConsoleLogOutput()
        let networkLogPrinter = NetworkLogPrinter(output: output)
        let networkLogger = NetworkLogger(printer: networkLogPrinter)
        let networkService = NetworkService(networkRequestPerformer: networkRequestPerformer, logger: networkLogger)
        let dataTransferService = DataTransferService<GenresResponseDTO>(networkService: networkService)
        let genresRepository = Repository(dataTransferService: dataTransferService)
        
        self.useCase = GetMovieGenresUseCase(repository: genresRepository)
        
    }
}

