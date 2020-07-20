//
//  uploadImages.swift
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
    
    func uploadFile(
        name: String,
        folderID: String,
        fileData: Data,
        mimeType: String,
        service: GTLRDriveService) {
        let file = GTLRDrive_File()
        file.name = name
        file.parents = [folderID]
        file.mimeType = "image/jpeg"
        let uploadParameters = GTLRUploadParameters(data: fileData, mimeType: mimeType)
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
        service.uploadProgressBlock = { _, totalBytesUploaded, totalBytesExpectedToUpload in
            print(totalBytesUploaded)
        }
        service.executeQuery(query) { (_, result, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            print("uploaded file")
        }
    }
    
    func uploadFiles(images: [UIImage],in parent: String ) {
        print("xxxx")
        if let uploadID = DriveFunctions.uploadIDs[parent]{
            for image in images{
                 let imgNameSubstring = "\(Date())".split(separator: " ")[0]
                 let imgName = "\(imgNameSubstring)"
                if let data = image.jpegData(compressionQuality: 0.5){
                        
                        uploadFile(
                        name: imgName,
                        folderID: uploadID,
                        fileData: data,
                        mimeType: "iapplication/vnd.google-apps.folder",
                        service: DriveFunctions.googleDriveService)
                        }
            }
        }
    }
}
