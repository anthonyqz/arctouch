//
//  ArcWebServices.swift
//  ArcTouch
//
//  Created by Christian Quicano on 11/13/16.
//  Copyright © 2016 ca9z. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord
import Alamofire
import AlamofireImage

class ArcWebServices: NSObject {
    
    //MARK: - class methods
    class func syncEntity(entity:AnyClass
        , url:String
        , key:String?
        , cleanAllData:Bool
        , completed:@escaping (()->())) {
        
        getJson(fromUrl: url
            , key: key
            , managedObject: entity
            , cleanAllData: cleanAllData
            , success: {
                completed()
        }) { (error) in
            completed()
            ArcUtil.showAlert(title: "Error Networking", message: error?.localizedDescription)
        }
        
    }
    
    class func download(imageName name:String?, downloaded:@escaping (_ image:UIImage)->()) {
        guard let name = name, let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return }
        let imagenName = name.replacingOccurrences(of: "/", with: "")
        let imagePath = "\(cachePath)/\(imagenName)"
        if let image = UIImage(contentsOfFile: imagePath) {
            downloaded(image)
        }else{
            let url = "\(urlImage)/\(imagenName)"
            Alamofire.request(url).responseImage { response in
                if let image = response.result.value {
                    do {
                        try UIImageJPEGRepresentation(image, 0.5)?.write(to: URL(fileURLWithPath: imagePath))
                    }catch{
                        print("can not save image")
                    }
                    downloaded(image)
                }
            }
        }
    }
    
    //MARK: - class methods for urls
    class func urlForUpcomingMovies(page:Int) -> String {
        return urlUpcomingMovies.replacingOccurrences(of: kPage, with: "\(page)")
    }
    
    //MARK: - private class
    class private func getJson(fromUrl url:String
        , key:String?
        , managedObject:AnyClass
        , cleanAllData:Bool
        , success successBlock:@escaping () -> ()
        , failure failureBlock:@escaping (_ error:Error?) -> ()) {
        
        Alamofire.request(url
            , method: .get
            , parameters: nil).responseJSON { (response) in
                if let json = response.result.value as? [String:AnyObject] {
                    
                    if cleanAllData {
                        let _ = managedObject.mr_truncateAll()
                    }
                    
                    if let key = key {
                        if let items = json[key] as? [[String:AnyObject]] {
                            var i = managedObject.mr_findAll()?.count ?? 0
                            for item in items {
                                if let _ = managedObject.mr_entityDescription()?.mr_attributeDescription(forName: kOrder) {
                                    var newItem = item
                                    newItem[kOrder] = "\(i)" as AnyObject
                                    let _ = managedObject.mr_import(from: newItem)
                                }else{
                                    let _ = managedObject.mr_import(from: item)
                                }
                                i = i + 1
                            }
                        }
                    }
                    
                    NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                    
                    successBlock()
                    
                }else{
                    failureBlock(response.result.error)
                }
        }
        
    }
}
