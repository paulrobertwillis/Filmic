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
