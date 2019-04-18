//
//  FilesManagerViewController.swift
//  Tutlane
//
//  Created by iMacbook on 4/18/19.
//  Copyright © 2019 IOTLink. All rights reserved.
//

import UIKit
let fileName: String = "text.txt"
let folderName: String = "/folder"
class FilesManagerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var actionTable: UITableView!
    var numberArray = NSMutableArray()
    var fileManager: FileManager?
    var documentDir: NSString?
    var filePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberArray.addObjects(from: ["Create File"])
        numberArray.addObjects(from: ["Create Directory"])
        numberArray.addObjects(from: ["Write File"])
        numberArray.addObjects(from: ["Read File"])
        numberArray.addObjects(from: ["Move File"])
        numberArray.addObjects(from: ["Copy File"])
        numberArray.addObjects(from: ["Directory Contains"])
        numberArray.addObjects(from: ["Remove File"])
        numberArray.addObjects(from: ["File Permissions"])
        fileManager = FileManager.default
        documentDir = "/Users/mac/ProjectTraining/IOSProject/Tutlane/Tutlane/Tutlane/te"
    
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return numberArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = numberArray.object(at: indexPath.row) as? String
        cell.selectionStyle = .default
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.row == 0 {
            filePath = documentDir?.appendingPathComponent(fileName)
            fileManager?.createFile(atPath: filePath!, contents: nil, attributes: nil)
            showAlert(_title: "Success", _message: "File created Successfully!")
        }
        else if indexPath.row == 1 {
            filePath = documentDir?.appendingPathComponent(folderName)
            do {
                try fileManager?.createDirectory(atPath: filePath!, withIntermediateDirectories: false, attributes: nil)
            } catch {
            }
            showAlert(_title: "Success", _message: "Directory created Successfully!")
        }
        else if indexPath.row == 2 {
            filePath = documentDir?.appendingPathComponent(fileName)
            let content: NSString = NSString("Hello world!")
            let fileContent:NSData = content.data(using: String.Encoding.utf8.rawValue)! as NSData
            fileContent.write(toFile: filePath!, atomically: true)
            showAlert(_title: "Success", _message: "Content written Successfully!")
        }
        else if indexPath.row == 3 {
            filePath = documentDir?.appendingPathComponent(fileName)
            let fileContent: NSData
            fileContent = fileManager?.contents(atPath: filePath!) as! NSData
            let str:NSString = NSString(data: fileContent as Data, encoding: String.Encoding.utf8.rawValue)!
            showAlert(_title: "Success", _message: "\(str)")
            
        }
        else if indexPath.row == 4 {
            let oldFilePath = documentDir?.appendingPathComponent(fileName)
            filePath = documentDir?.appendingPathComponent("\(folderName)/\(fileName)")
            var err: NSError?
            do {
                try fileManager?.moveItem(atPath: oldFilePath!, toPath: filePath!)
            } catch let error as NSError{
                err = error
            }
            if (err != nil){
                print(err!)
            }
            else {
                showAlert(_title: "Success", _message: "File moved successfully!")
            }
        }
        else if indexPath.row == 5 {
            let oldFilePath = documentDir?.appendingPathComponent(fileName)
            filePath = documentDir?.appendingPathComponent("\(folderName)\(fileName)")
            do {
                try fileManager?.copyItem(atPath: oldFilePath!, toPath: filePath!)
            } catch {
            }
            showAlert(_title: "Success", _message: "File coppied successfully!")
        }
        else if indexPath.row == 6 {
            var error: NSError? = nil
            var arrDirContent: [AnyObject]?
            do {
                arrDirContent = try fileManager!.contentsOfDirectory(atPath: documentDir! as String) as [AnyObject]
            }
            catch let error1 as NSError{
                error = error1
                arrDirContent = nil
            }
            if (error != nil) {
                print(error!)
            }
            else {
                showAlert(_title: "Success", _message: "Content of Directory: \(arrDirContent)")
            }
            
        }
        else if indexPath.row == 7 {
            filePath = documentDir?.appendingPathComponent(fileName)
            do {
                try fileManager?.removeItem(atPath: filePath!)
            }
            catch {
            }
            showAlert(_title: "Success", _message: "File removed Successfully")
        }
        else if indexPath.row == 8 {
            filePath = documentDir?.appendingPathComponent(fileName)
            var filePermissions:NSString = ""
            if (fileManager?.isWritableFile(atPath: filePath!) != nil){
                filePermissions = filePermissions.appendingPathComponent("file is writable") as NSString
            }
            if (fileManager?.isReadableFile(atPath: filePath!) != nil){
                filePermissions = filePermissions.appendingPathComponent("file is writable") as NSString
            }
            if (fileManager?.isExecutableFile(atPath: filePath!) != nil){
                filePermissions = filePermissions.appendingPathComponent("file is writable") as NSString
            }
            showAlert(_title: "Success", _message: "\(filePermissions)")
        }
    }
    
    func showAlert(_title: String, _message: String) {
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
