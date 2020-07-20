//
//  getImages.swift
//  WeScan
//
//  Created by Sahil Mirchandani on 7/19/20.
//  Copyright © 2020 Sahil Mirchandani. All rights reserved.
//

import Foundation
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher

extension DriveFunctions{
    
    func getFileList(
        service: GTLRDriveService,
        user: GIDGoogleUser, parentID: String, parentName: String){
        let query = GTLRDriveQuery_FilesList.query()
        query.spaces = "drive"
        query.corpora = "user"
        let filesOnly = "mimeType = 'image/jpeg'"
        DriveFunctions.imageIDs[parentName] = []
        query.q = "\(filesOnly) and '\(parentID)' in parents and trashed = false"
        service.executeQuery(query) { (_, result, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            let folderList = result as! GTLRDrive_FileList
            if let files = folderList.files{
                
                for i in files{
                    let fileId = i.identifier!
                    let temporaryFolder = URL.init(fileURLWithPath: NSTemporaryDirectory())
                    let destinationFileURL = temporaryFolder.appendingPathComponent(i.identifier! + ".jpg")
                    let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileId)
                    let downloadRequest = service.request(for: query) as URLRequest
                    let fetcher = service.fetcherService.fetcher(with: downloadRequest)
                    fetcher.destinationFileURL = destinationFileURL
                    fetcher.beginFetch { (data, error) in
                        if let error = error {
                            print("__ ERROR on fetching data: \(error.localizedDescription)")
                        }
                    }
                    fetcher.downloadProgressBlock = { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                        //print((bytesWritten, totalBytesWritten, totalBytesExpectedToWrite))
                    }
                    DriveFunctions.imageIDs[parentName]?.insert(i.identifier!)
                }
            }
        }
    }
    
    func populateImages(){
        
        for folder in DriveFunctions.folders{
            if let user = DriveFunctions.googleUser, let id = DriveFunctions.uploadIDs[folder]{
                print("getting images for \(folder)")
                getFileList(service: DriveFunctions.googleDriveService, user: user, parentID: id, parentName: folder)
            }
        }
    }
}
