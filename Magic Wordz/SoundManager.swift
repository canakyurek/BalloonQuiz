//
//  AudioPlayerPool.swift
//  Magic Wordz
//
//  Created by Can Akyurek on 7.07.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import Foundation
import AVFoundation


enum Sound: String {
    case inGame = "bossa"
}

class SoundManager: NSObject {
    
    lazy private var players = [AVAudioPlayer]()
    
    static let shared = SoundManager()
    
    private override init() {}
    
    func play(_ trackName: Sound) {
        if let url = Bundle.main.url(forResource: trackName.rawValue,
                                     withExtension: "mp3"),
            let player = self.player(url: url) {
            DispatchQueue.global(qos: .background).async {
                player.numberOfLoops = -1
                player.prepareToPlay()
                player.play()
            }
        }
    }
    
    func stop(_ trackName: Sound) {
        if let url = Bundle.main.url(forResource: trackName.rawValue,
                                     withExtension: "mp3") {
            let player = players.filter({ return $0.isPlaying && $0.url == url})
            player.first?.stop()
        }
    }
    
    // Filters audio players from private array and increases player
    // reusability. If none, adds a new one.
    private func player(url: URL) -> AVAudioPlayer? {
        let availablePlayers = players.filter { (player) -> Bool in
            return player.isPlaying == false && player.url == url
        }
        
        // If there is any player, return it
        if let playerToUse = availablePlayers.first {
            return playerToUse
        }
        
        // If there is none, create one
        do {
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            players.append(newPlayer)
            
            return newPlayer
        } catch {
            return nil
        }
    }
}
