//
//  WifiViewController.swift
//  MusicMyself
//
//  Created by XYU on 02/12/2020.
//

import UIKit

class WifiViewController: UIViewController, DirectoryMonitorDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackground()
        
        //默认上传目录是App的用户文档目录
        let documentsPath = NSHomeDirectory() + "/Documents"
        print(documentsPath)
        
        let webUploader = GCDWebUploader(uploadDirectory: documentsPath)
        webUploader.start(withPort: 8080, bonjourName: "Web Based Uploads")
        print("服务启动成功，使用你的浏览器访问：\(webUploader.serverURL)")
    
        monitor()
    }
    
    func monitor()
    {
        var applicationDocumentsDirectory: URL {
                return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        }
        
        var dm = DirectoryMonitor(url: applicationDocumentsDirectory)
        dm.delegate = self
        dm.startMonitoring()
    }
    
    func hello() {
        let webServer = GCDWebServer()
                 
        webServer.addDefaultHandler(forMethod: "GET", request: GCDWebServerRequest.self,
                                     processBlock: {request in
            let html = "<html><body>欢迎访问 <b>paris8.org</b></body></html>"
            return GCDWebServerDataResponse(html: html)
             
        })
         
        webServer.start(withPort: 8080, bonjourName: "GCD Web Server")
        print("服务启动成功，使用你的浏览器访问：\(webServer.serverURL)")
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
    
    func directoryMonitorDidObserveChange(directoryMonitor: DirectoryMonitor) {
        print("*******")
        print(directoryMonitor.monitoredDirectoryFileDescriptor)
    }
}
