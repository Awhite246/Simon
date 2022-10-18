//
//  AudioPlayer.swift
//  Simon
//
//  Created by Alistair White on 10/13/22.
//

import Foundation
import AVFoundation

class AudioPlayer: ObservableObject {
    var player = AVAudioPlayer()
    
    init(name: String, type: String, volume: Float = 1) {
        if let url = Bundle.main.url(forResource: name, withExtension: type) {
            print("success audio file \(name)")
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                player.setVolume(volume, fadeDuration: 0)
            } catch {
                print("error getting audio \(error.localizedDescription)")
            }
        }
    }
    
    func start() {
        player.play()
    }
    func pause() {
        player.pause()
    }
    func toggle() {
        if player.isPlaying {
            start()
        } else {
            pause()
        }
    }
}
