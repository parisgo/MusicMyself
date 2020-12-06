//
//  WifiViewController.swift
//  MusicMyself
//
//  Created by XYU on 02/12/2020.
//

import UIKit

class WifiViewController: UIViewController {
    let documentsPath = NSHomeDirectory() + "/Documents/Files"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackground()
        
        print(documentsPath)
        
        let webUploader = GCDWebUploader(uploadDirectory: documentsPath)
        webUploader.start(withPort: 8080, bonjourName: "Web Based Uploads")
        webUploader.allowedFileExtensions = ["mp3"]
        
        if webUploader.serverURL != nil {
            print("服务启动成功，使用你的浏览器访问：\(webUploader.serverURL)")
        }
        else {
            print("Can not connect with Wifi")
        }
    }

    func addBackground() {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "bg_heart.png")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        
        self.view.addSubview(imageViewBackground)
    }
    
    
    func monitor()
    {
        let dm = DirectoryMonitor(url: URL(fileURLWithPath: documentsPath))
        
        //DirectoryMonitorDelegate
        //dm.delegate = self
        //dm.startMonitoring()
    }
    
    func directoryMonitorDidObserveChange(directoryMonitor: DirectoryMonitor) {
        //print(directoryMonitor.directoryMonitorSource?.data)
        DispatchQueue.main.async {
            //self?.updateFileList()
        }
    }
}
