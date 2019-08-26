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

class MusicPlayer: NSObject {
    
    static let shared = MusicPlayer()
    var audioPlayer: AVAudioPlayer?
    
    func play(withName name: Sound) {
        guard let path = Bundle.main.path(forResource: name.rawValue, ofType: "mp3") else {
            return
        }
        let musicURL = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: musicURL)
            
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.numberOfLoops = -1
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print(error)
        }
    }
    
    func playInGameSound() {
        play(withName: .inGame)
    }
    
    func pause() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.pause()
    }
    
    func stop() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.stop()
    }
}
