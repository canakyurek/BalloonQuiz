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
                    self.indicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }
            task.resume()
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
        return players.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let player = players[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell",
                                                 for: indexPath) as! LeaderboardCell
        if indexPath.row == 3 {
            let labels = cell.contentView.subviews.compactMap({ $0 as? UILabel })
            labels.forEach({ $0.textColor = UIColor(named: "lightBlue") })
        }
        
        cell.rankLabel.text = "\(indexPath.row + 1)"
        cell.usernameLabel.text = player.username
        cell.scoreLabel.text = "\(player.score)"
        
        return cell
    }
}

extension LeaderboardViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
