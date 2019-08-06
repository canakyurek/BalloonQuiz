//
//  WordListViewController.swift
//  Balloon
//
//  Created by Can Akyurek on 27.04.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

class WordListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowRadius = 3.0
            contentView.layer.shadowOpacity = 0.2
            contentView.layer.shadowOffset = CGSize(width: 0, height: 3)
            contentView.layer.masksToBounds = false
        }
    }
    
    var corrects: [Answer]?
    var wrongs: [Answer]?
    var dataSource = [Answer]()
    
    @IBAction func closeTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = Localizable.SideEndings.wordList.localized
        let segment = SegmentedControl(frame: CGRect(
            x: 50,
            y: 70,
            width: self.view.frame.width - 100,
            height: 50),
            buttonTitles: [Localizable.SideEndings.known.localized, Localizable.SideEndings.unknown.localized]
        )
        segment.delegate = self
        view.addSubview(segment)
        
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        dataSource = corrects!
        tableView.reloadData()
    }

}

extension WordListViewController: SegmentedControlDelegate {
    func didChangeToIndex(_ index: Int) {
        if index == 0 {
            dataSource = corrects!
        } else {
            dataSource = wrongs!
        }
        tableView.reloadData()
    }
}

extension WordListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath) as! WordCell
        cell.originalWordLabel.text = dataSource[indexPath.row].originalWord
        cell.correspondingWordLabel.text = dataSource[indexPath.row].correctAnswer

        return cell
    }
}
