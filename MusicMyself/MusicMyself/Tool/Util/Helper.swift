//
//  Tool.swift
//  MusicMyself
//
//  Created by XYU on 05/12/2020.
//

import Foundation

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
}
