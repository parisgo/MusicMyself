//
//  WifiViewController.swift
//  MusicMyself
//
//  Created by XYU on 02/12/2020.
//

import UIKit

class WifiViewController: UIViewController {
    
    @IBOutlet weak var txtViewInfo: UITextView!
    
    let documentsPath = NSHomeDirectory() + "/Documents/Files"
    var webUploader: GCDWebUploader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addBackground()
        
        webUploader = GCDWebUploader(uploadDirectory: documentsPath)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func clickStart(_ sender: Any) {
        if ((sender as AnyObject).isOn == true) {
            if(!webUploader.isRunning) {
                webUploader.start(withPort: 8080, bonjourName: "Web Based Uploads")
            }
            webUploader.allowedFileExtensions = ["mp3"]
            
            if webUploader.serverURL != nil {
                txtViewInfo.text = "服务启动成功，可以使用你的浏览器访问：\(webUploader.serverURL!)";
            }
            else {
                txtViewInfo.text = "Can not connect with Wifi"
            }
        }
        else {
            if(webUploader.isRunning) {
                webUploader.stop()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            if(webUploader.isRunning) {
                webUploader.stop()
            }
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
