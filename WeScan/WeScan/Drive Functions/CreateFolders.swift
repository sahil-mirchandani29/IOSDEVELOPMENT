//
//  CreateFolders.swift
//  WeScan
//
//  Created by Sahil Mirchandani on 7/18/20.
//  Copyright © 2020 Sahil Mirchandani. All rights reserved.
//

import Foundation
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher

public extension DriveFunctions{
    
    func createFolder(
        name: String,
        service: GTLRDriveService, parent: String?, root:Bool){
        
        let folder = GTLRDrive_File()
        folder.mimeType = "application/vnd.google-apps.folder"
        folder.name = name
        if(root == false){
            print("creating child with parent \(parent!))")
            folder.parents = [parent!]
        }
        let query = GTLRDriveQuery_FilesCreate.query(withObject: folder, uploadParameters: nil)
        
        service.executeQuery(query) { (_, file, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            print("created")
            let folder = file as! GTLRDrive_File
            if(root == true){
                DriveFunctions.rootFolderID = folder.identifier
            }
            if(root == false){
                DriveFunctions.folders.append(name)
                DriveFunctions.uploadIDs[name] = folder.identifier
            }
        }
    }
    func createDriveFolder(name:String, root:Bool) {
        if (root == true ){
            createFolder(
                name: "WeScan",
                service: DriveFunctions.googleDriveService, parent: nil, root: true)
        }else{
            if let parent = DriveFunctions.rootFolderID{
                createFolder(
                    name: name,
                    service: DriveFunctions.googleDriveService, parent: parent, root: false)
            }
            else{
                if let user = DriveFunctions.googleUser{
                    self.populateRootFolder(user: user, service: DriveFunctions.googleDriveService)
                }
            }
        }
    }
}
