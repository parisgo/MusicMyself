//
//  Tool.swift
//  MusicMyself
//
//  Created by XYU on 05/12/2020.
//

import Foundation
import UIKit

class Helper: NSObject {
    class func checkImage(id: Int) -> String! {
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/Images/\(id).jpg"
        
        if (fileManager.fileExists(atPath: filePath)){
            return filePath;
        }
        
        return nil;
    }
    
    class func getImage(id: Int) -> UIImage {
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/Images/\(id).jpg"
        
        if (FileManager.default.fileExists(atPath: filePath)){
            return UIImage.init(contentsOfFile: filePath)!
        }
        
        return UIImage(named: "bg_heart.png")!
    }
    
    class func checkFile(name: String) -> String! {
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/Files/\(name)"
        
        if (fileManager.fileExists(atPath: filePath)){
            return filePath;
        }
        
        return nil;
    }
    
    class func getFichierPath() -> String! {
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/Files/"
        
        return filePath;
    }
}
