//
//  CollectionViewController.swift
//  MovieApp
//
//  Created by Paul on 12/06/2022.
//

import UIKit

class SearchCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        self.collectionView.dataSource = self
        let cellNib = UINib(nibName: CollectionViewCell.reuseIdentifier, bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        
        
        let networkRequestPerformer = NetworkRequestPerformer()
        let output = ConsoleLogOutput()
        let printer = NetworkLogPrinter(output: output)
        let logger = NetworkLogger(printer: printer)
        let networkService = NetworkService(networkRequestPerformer: networkRequestPerformer, logger: logger)
        
        let dataTransferService = DataTransferService<GenresResponseDTO>(networkService: networkService)
        let repository = GenresRepository(dataTransferService: dataTransferService)
        let useCase = GetMovieGenresUseCase(repository: repository)
        
        useCase.execute { result in
            switch result {
            case .success(let genres):
                print(genres)
            case .failure(let error):
                print(error)
            }
        }

        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetail", sender: nil)
    }
    
}


class CollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: CollectionViewCell.self)
}
