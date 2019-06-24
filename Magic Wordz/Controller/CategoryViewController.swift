//
//  CategoryViewController.swift
//  Balloon
//
//  Created by Can Akyurek on 18.06.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        let nib = UINib(nibName: "CategoryCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CategoryCell")
    }
}

extension CategoryViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.titleLabel.text = "History"
        cell.imageView.image = UIImage(named: "history")
        
        return cell
    }
}
