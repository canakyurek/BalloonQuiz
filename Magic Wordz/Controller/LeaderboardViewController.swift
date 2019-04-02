//
//  LeaderboardViewController.swift
//  Balloon
//
//  Created by Can Akyurek on 30.03.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit
import GameKit

class LeaderboardViewController: UIViewController {

    var score = 0
    var players = [Player]()
    
    @IBOutlet weak var indicator: UIActivityIndicatorView! {
        didSet {
            indicator.hidesWhenStopped = true
            indicator.startAnimating()
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getLeaderboard()
    }
    
    func getLeaderboard() {
        let path = "https://magic-wordz.herokuapp.com/players"
        if let url = URL(string: path) {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let baseData = try! JSONDecoder().decode(BaseModel.self, from: data!)
                self.players = baseData.msg
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            task.resume()
        }
    }
}

extension LeaderboardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension LeaderboardViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
