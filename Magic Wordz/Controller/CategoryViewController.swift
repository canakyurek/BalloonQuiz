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
    
    var questions: [Question]?
    var dataSource = ["1", "1", "1", "1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "CategoryCell", bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: "CategoryCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startGameSegue" {
            if let destination = segue.destination as? GameViewController {
                destination.questions = questions
            }
        }
    }
}

extension CategoryViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.isFirst = indexPath.row == (dataSource.count - 1)
        
        return cell
    }
}

extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "startGameSegue", sender: nil)
    }
}
