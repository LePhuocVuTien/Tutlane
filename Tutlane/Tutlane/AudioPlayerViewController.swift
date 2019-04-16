//
//  AudioPlayerViewController.swift
//  Tutlane
//
//  Created by iMacbook on 4/10/19.
//  Copyright © 2019 IOTLink. All rights reserved.
//

import UIKit
import AVFoundation

var myAudioPlayer = AVAudioPlayer()

class AudioPlayerViewController: UIViewController {
    
    
   
    @IBOutlet weak var volumeAudio: UISlider!
    
    @IBAction func btnStop(_ sender: Any) {
        myAudioPlayer.stop()
        myAudioPlayer.currentTime = 0
    }
    
    
    @IBAction func btnPause(_ sender: Any) {
        myAudioPlayer.pause()
        print ("currentTime of audio: \(String(myAudioPlayer.currentTime))")
    }
    
    @IBAction func btnPlay(_ sender: Any) {
        myAudioPlayer.play()
    }
    
    
    @IBAction func volumeControls(_ sender: Any) {
        myAudioPlayer.volume = volumeAudio.value
        print ("Volume of audio: \(String(myAudioPlayer.volume))")
        
    }
    
    var myAudioPlayer = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myFilePathString = Bundle.main.path(forResource: "music.mp3", ofType: nil, inDirectory: nil )
        print ("URL: \(String(describing: myFilePathString))")
        
        if let myFilePathString = myFilePathString{
            let myFilePathURL = URL(fileURLWithPath: myFilePathString)
            do {
                myAudioPlayer = try AVAudioPlayer(contentsOf: myFilePathURL)
                myAudioPlayer.play()
            }
            catch{
                // Can not load File
                print ("Error")
            }
        }
    }
}
