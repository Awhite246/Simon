//
//  AudioPlayer.swift
//  Simon
//
//  Created by Alistair White on 10/13/22.
//

import Foundation
import AVFoundation

//class to play audio
class AudioPlayer: ObservableObject {
    var player = AVAudioPlayer()
    
    init(name: String, type: String, volume: Float = 1) {
        //creates path to sound file
        if let url = Bundle.main.url(forResource: name, withExtension: type) {
            print("success audio file \(name)")
            do {
                //sets up audio file to be played
                player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                player.setVolume(volume, fadeDuration: 0)
            } catch {
                //if audio file doesnt exist
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
    //if playing pause, and if paused play
    func toggle() {
        if player.isPlaying {
            start()
        } else {
            pause()
        }
    }
}
