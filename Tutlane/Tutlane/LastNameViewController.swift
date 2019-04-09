//
//  LastNameViewController.swift
//  Tutlane
//
//  Created by iMacbook on 4/9/19.
//  Copyright © 2019 IOTLink. All rights reserved.
//

import UIKit

protocol DataSendDelegate {
    func userDidEnterData(data: String)
}

class LastNameViewController: UIViewController {
    
    var delegate: DataSendDelegate? = nil
    
    @IBOutlet weak var textFields: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnSendMassage(_ sender: Any) {
        if (delegate != nil){
            if (textFields.text != nil){
                let data = textFields.text
                delegate?.userDidEnterData(data: data!)
                dismiss(animated: true, completion: nil)
            }
        }
    }

}
