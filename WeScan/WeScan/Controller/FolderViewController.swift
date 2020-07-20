//
//  FolderViewController.swift
//  WeScan
//
//  Created by Sahil Mirchandani on 7/17/20.
//  Copyright © 2020 Sahil Mirchandani. All rights reserved.
//

import UIKit

class FolderViewController: UIViewController {
    
    var folders:[String] = []{
        didSet{
            folderTableView.reloadData()
        }
    }
    @IBOutlet weak var folderTableView: UITableView!
    var driveFunctions = DriveFunctions()
    var selectedRow:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        folderTableView.dataSource = self
        folderTableView.delegate = self
        folderTableView.rowHeight = 60.0
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        DriveFunctions.folderViewController = self
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        driveFunctions.getFolders(){(folder) -> Void in
            self.folders = folder
        }
        driveFunctions.populateImages()
    }
    

    @IBAction func addNewFolderPressed(_ sender: UIButton) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Craete New Folder", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New Folder", style: .default)
            { (action) in
                self.driveFunctions.createDriveFolder(name: textField.text!, root: false)
                self.folders.append(textField.text!)
                self.folders.sort()
        }
        alert.addTextField
            { (alertTextField) in
                alertTextField.placeholder = "Name of New folder"
                textField = alertTextField
            }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
}

//MARK: - TableView Delegates
extension FolderViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Folder", for: indexPath)
        cell.textLabel?.text = folders[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = folders[indexPath.row]
        performSegue(withIdentifier: "ImagesView", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImagesView"{
            let ImagesViewController = segue.destination as! ImagesViewController
            if let folder = selectedRow{
                 ImagesViewController.folderName = folder
            }
        }
    }
    
    
}
