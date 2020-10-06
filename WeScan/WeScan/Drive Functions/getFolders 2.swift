//
//  getFolders.swift
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
    
    
    func populateRootFolder(user: GIDGoogleUser, service: GTLRDriveService){
        let query = GTLRDriveQuery_FilesList.query()
        query.spaces = "drive"
        query.corpora = "user"
        let withName = "name = 'WeScan'" // Case insensitive!
        let foldersOnly = "mimeType = 'application/vnd.google-apps.folder'"
        let ownedByUser = "'\(user.profile!.email!)' in owners"
        query.q = "\(withName) and \(foldersOnly) and \(ownedByUser) and trashed = false"
        service.executeQuery(query) { (_, result, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            let folderList = result as! GTLRDrive_FileList
            if let rootID = folderList.files?.first{
                DriveFunctions.rootFolderID = rootID.identifier
                self.populateFolders(service: service, user: user, parentID: DriveFunctions.rootFolderID!)
            }
            else{
                print("NoFolder WESCAN")
                self.createDriveFolder(name: "WeScan", root: true)
            }
        }
        
    }
    
    
    func populateFolders(
        service: GTLRDriveService,
        user: GIDGoogleUser, parentID: String){
        
        let query = GTLRDriveQuery_FilesList.query()
        query.spaces = "drive"
        query.corpora = "user"
        let foldersOnly = "mimeType = 'application/vnd.google-apps.folder'"
        let ownedByUser = "'\(user.profile!.email!)' in owners"
        query.q = "\(foldersOnly) and \(ownedByUser) and '\(parentID)' in parents and trashed = false"
        
        service.executeQuery(query) { (_, result, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            let folderList = result as! GTLRDrive_FileList
            var tempFolderList:[String] = []
            var tempUploadIds = [String: String]()
            if let files = folderList.files{
                for i in files{
                    tempFolderList.append(i.name!)
                    tempUploadIds[i.name!]  = i.identifier!
                }
            }
            DriveFunctions.folders = tempFolderList.sorted()
            DriveFunctions.uploadIDs = tempUploadIds
        }
    }
    
    func getFolders(completion: ([String]) -> ()) {
        if let id = DriveFunctions.rootFolderID, let user = DriveFunctions.googleUser{
            populateFolders(service: DriveFunctions.googleDriveService, user: user, parentID: id)
        }
        else{
            if let user = DriveFunctions.googleUser{
                populateRootFolder(user: user, service: DriveFunctions.googleDriveService)
            }
        }
        completion(DriveFunctions.folders)
    }
}
