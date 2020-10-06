//
//  ImagesViewController.swift
//  WeScan
//
//  Created by Sahil Mirchandani on 7/18/20.
//  Copyright © 2020 Sahil Mirchandani. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class ImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
 
    @IBOutlet weak var ImagesCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    var image: UIImageView?
    var folderName: String?
    var selectedrow: Int?
    var numberOfImages: Int?{
        didSet{
            ImagesCollectionView.reloadData()
        }
    }
    var images: [UIImage]=[]
    var driveFunctions = DriveFunctions()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        ImagesCollectionView.delegate = self;
        ImagesCollectionView.dataSource = self;
        DriveFunctions.ImagesViewController = self;
        let nibCell = UINib(nibName: "CollectionViewCell", bundle: nil)
        ImagesCollectionView.register(nibCell, forCellWithReuseIdentifier: "CollectionViewCell")
        if let name = folderName{
            titleLabel.text = name
            //numberOfImages = DriveFunctions.imageIDs[name]?.count
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "cameraButtonPressed", sender: self)
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        ImagesCollectionView.reloadData()
    }
}

extension ImagesViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let number = numberOfImages{
            if(number > 0){
                return number
            }
        }
        return 1
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        DispatchQueue.main.async {
            let tempfolder = NSTemporaryDirectory()
            var flag = false
            if let number = self.numberOfImages{
                if(number >= indexPath.row && number != 0 ){
                    if let id = DriveFunctions.imageIDs[self.folderName!]{
                        if let image = UIImage(contentsOfFile: "\(tempfolder)/\(String(describing: id[indexPath.row])).jpg"){
                              cell.cellImgView.image = image
                                flag = true
                          }
                        }
                    }
                }
                if(flag == false){
                    cell.cellImgView.image = UIImage(named: "Nodata")
                }
            }
   
        cell.imgTitle.text = ""
        
        //cell.layer.borderColor = UIColor.darkGray.cgColor
        //cell.layer.borderWidth = 1
        return cell
        
     }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedrow = indexPath.row
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ImageSegue", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageSegue"{
            let imageViewController = segue.destination as! ImageViewController
            if let id = DriveFunctions.imageIDs[self.folderName!]{
            let tempfolder = NSTemporaryDirectory()
            if let image = UIImage(contentsOfFile: "\(tempfolder)/\(String(describing: id[selectedrow!])).jpg"){
                imageViewController.image = image
              }
            }
        }
    }
}
