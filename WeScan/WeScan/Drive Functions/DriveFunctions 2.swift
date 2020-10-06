//
//  DriveFunctions.swift
//  WeScan
//
//  Created by Sahil Mirchandani on 7/18/20.
//  Copyright © 2020 Sahil Mirchandani. All rights reserved.
//

import Foundation
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher

public class DriveFunctions{
    static var userName: String?
    static var userEmail: String?
    static var googleDriveService = GTLRDriveService()
    static var googleUser: GIDGoogleUser?
    static var rootFolderID: String?
    static var driveFunctions = DriveFunctions()
    static var folders: [String] = []{
        didSet{
            DriveFunctions.folderViewController?.folders = DriveFunctions.folders
            DriveFunctions.CameraViewController?.folders = DriveFunctions.folders
        }
    }
    static var uploadIDs = [String: String]()
    static var folderViewController: FolderViewController?
    static var CameraViewController: CameraViewController?
    static var imageIDs = [String: Set<String>](){
        didSet{
            updateImages()
        }
    }
    static var images = [String: UIImage]()
    
    
    static func updateImages(){
        var tempfolder = NSTemporaryDirectory()
        for folder in DriveFunctions.folders{
            if let set = DriveFunctions.imageIDs[folder]{
                for id in set{
                    if(DriveFunctions.images[id] == nil){
                        if let image = UIImage(contentsOfFile: "\(tempfolder)/\(id).jpg"){
                            DriveFunctions.images[id] = image
                        }
                    }
                }
            }
        }
        tempfolder.removeAll()
    }
    
}
