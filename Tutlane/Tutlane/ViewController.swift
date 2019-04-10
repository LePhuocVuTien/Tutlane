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
    func userEnterData(data: NSString) {
        receivingLabel.text = data as String
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSendingVC" {
            let lastNameVC: LastNameViewController = segue.destination as! LastNameViewController
            lastNameVC.delegate = self
        }
    }
}
