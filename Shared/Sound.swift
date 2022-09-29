//
//  Sound.swift
//  Simon
//
//  Created by Alistair White on 9/29/22.
//

//Source: https://stackoverflow.com/questions/59404039/how-to-play-audio-using-avaudioplayer-in-swiftui-project


import Foundation
import AVFoundation

class Sound {
    static var audioPlayer:AVAudioPlayer?
    
    static func playSound(soundfile: String) {
        if let path = Bundle.main.path(forResource: soundfile, ofType: nil){
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            }catch {
                print("Error")
            }
        }
    }
}
