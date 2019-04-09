//
//  ViewController.swift
//  Tutlane
//
//  Created by iMacbook on 4/9/19.
//  Copyright © 2019 IOTLink. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DataSendDelegate {

    @IBOutlet weak var receivingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func userDidEnterData(data: String) {
        receivingLabel.text = data
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSendingVC" {
            let sendingVC: LastNameViewController = segue.destination as! LastNameViewController
            sendingVC.delegate = self
        }
    }
}

