//
//  AlertViewController.swift
//  Tutlane
//
//  Created by iMacbook on 4/18/19.
//  Copyright © 2019 IOTLink. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnAlert(_ sender: Any) {
        let alert = UIAlertController(title: "IOLINK", message: "You have touch her face!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action:UIAlertAction!) in
            print("You have pressed the Cancel button")
            }))
        self.present(alert, animated: true, completion: nil)
    }
}
