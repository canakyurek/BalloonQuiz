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
    var dataList = [GKScore]()
    let leaderboardID = "highscores"
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        obtainLeaderboard()
    }
    
    func obtainLeaderboard() {
        let leaderboardRequest = GKLeaderboard()
        leaderboardRequest.playerScope = .global
        leaderboardRequest.timeScope = .allTime
        leaderboardRequest.identifier = leaderboardID
        leaderboardRequest.loadScores { (scores, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                guard let scores = scores else { return }
                DispatchQueue.main.async {
                    self.dataList = scores
                    self.indicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LeaderboardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell",
                                                 for: indexPath) as! LeaderboardCell
        
        cell.rankLabel.text = "\(indexPath.row + 1)"
        cell.usernameLabel.text = data.player.alias
        cell.scoreLabel.text = data.formattedValue ?? "\(data.value)"
        
        return cell
    }
}
