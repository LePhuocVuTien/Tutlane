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

    
    @IBOutlet weak var myVolumeController: UISlider!
    
    
    @IBAction func btnStop(_ sender: Any) {
        myAudioPlayer.stop()
        myAudioPlayer.currentTime = 0
    }
    
    @IBAction func volumeControl(_ sender: Any) {
        myAudioPlayer.volume = myVolumeController.value
    }
    
    @IBAction func btnPause(_ sender: Any) {
        myAudioPlayer.pause()
    }
    
    @IBAction func btnPlay(_ sender: Any) {
       // myAudioPlayer.play()
    }
    
    var myAudioPlayer = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let myFilePathString = Bundle.main.path(forResource: "nhac.mp3", ofType: nil)
        
        //let player = AVPlayer(url: Bundle.main.url(forResource: "nhac", withExtension: "mp3")!)
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
