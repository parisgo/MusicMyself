//
//  WifiViewController.swift
//  MusicMyself
//
//  Created by XYU on 02/12/2020.
//

import UIKit

class WifiViewController: UIViewController {
    var httpServer : HTTPServer! = nil
    var isOPen:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        addBackground()
        
        httpServer = HTTPServer()
        httpServer.setType("_http.tcp")
        
        print("\(NSHomeDirectory())/Documents")
        httpServer.setDocumentRoot("\(NSHomeDirectory())/Documents")
        
        isOPen = !isOPen
        if isOPen{
            do{
                try httpServer.start()
                print( "请打开以下网址: http://\(HTTPHelper.ipAddress() ?? ""):\(httpServer.listeningPort())")
            }catch{
                print("启动失败")
            }
            
        }else{
            httpServer.stop()
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
}
