//
//  CameraViewController.swift
//  WeScan
//
//  Created by Sahil Mirchandani on 7/17/20.
//  Copyright © 2020 Sahil Mirchandani. All rights reserved.
//

import UIKit
import VisionKit
import Vision
import SwiftGifOrigin

class CameraViewController: UIViewController, VNDocumentCameraViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var folders: [String] = []{
        didSet{
            folderPickerView.reloadAllComponents()
        }
    }
    var driveFunctions = DriveFunctions()
    var images: [UIImage] = []
    @IBOutlet weak var folderPickerView: UIPickerView!
    @IBOutlet weak var imgView: UIImageView!
    var didCancel = false
    var selectedRow: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        folderPickerView.delegate = self
        folderPickerView.dataSource = self
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        DriveFunctions.CameraViewController = self
        driveFunctions.getFolders(completion: { (fold) in
            self.folders = fold
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        if(didCancel == false){
        super.viewDidAppear(animated)
        if(images.count < 1){
             scanDocument()
            imgView.image = UIImage(named: "Nodata")
        }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didCancel = false
    }
    
    func scanDocument() {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = self
        present(scannerViewController, animated: true)
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        if(images.count > 0){
            if let folder = selectedRow{
                driveFunctions.uploadFiles(images: images, in: folder)
                imgView.image =  UIImage.gif(asset: "SavedImage")
                images = []
            }
        }
      
    }
}

//MARK: - Scanning
extension CameraViewController{
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        for pageNumber in 0..<scan.pageCount {
            images.append(scan.imageOfPage(at: pageNumber))
        }
        imgView.image = scan.imageOfPage(at: 0)
        controller.dismiss(animated: true)
    }
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        didCancel = true
        controller.dismiss(animated: true)
    }
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true)
    }
}

extension CameraViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return folders.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return folders[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       selectedRow = folders[row]
    }
}
