//
//  ImagesViewController.swift
//  WeScan
//
//  Created by Sahil Mirchandani on 7/18/20.
//  Copyright © 2020 Sahil Mirchandani. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
 
    @IBOutlet weak var ImagesCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    var image: UIImageView?
    var folderName: String?
    var images: [UIImage]=[]
    var driveFunctions = DriveFunctions()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        ImagesCollectionView.delegate = self;
        ImagesCollectionView.dataSource = self;
        let nibCell = UINib(nibName: "CollectionViewCell", bundle: nil)
        ImagesCollectionView.register(nibCell, forCellWithReuseIdentifier: "CollectionViewCell")
        if let name = folderName{
            titleLabel.text = name
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
        
        if let name = folderName{
        if let imagesSet = DriveFunctions.imageIDs[name]{
            for imageID in imagesSet{
                if let image = DriveFunctions.images[imageID]{
                    images.append(image)
                }
            }
            if(imagesSet.count == 0){
                return 1
            }
            return imagesSet.count
        }
        }
        return 1
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        if(images.count != 0){
            if(images.count > indexPath.row){
                cell.cellImgView.image = images[indexPath.row]
                cell.imgTitle.text = "1.jpg"
            }
            else{
                cell.cellImgView.image = UIImage(named: "Nodata")
                cell.imgTitle.text = ""
            }
        }
        else{
            cell.cellImgView.image = UIImage(named: "Nodata")
            cell.imgTitle.text = ""
        }
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 1
        return cell
        
     }
}
