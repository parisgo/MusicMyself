//
//  FichierDetailViewController.swift
//  MusicMyself
//
//  Created by XYU on 05/12/2020.
//

import UIKit

class FichierDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var fichierImg: UIImageView!
    @IBOutlet weak var fichierTitle: UITextField!
    @IBOutlet weak var fichierAuthor: UITextField!
    
    var fichier: Fichier!
    
    var callback : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        fichierImg.addGestureRecognizer(tapGR)
        fichierImg.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if let tmp = fichier {
            fichierTitle.text = tmp.title
            fichierAuthor.text = tmp.author
        }
    }
    
    override func viewDidDisappear(_ animated : Bool) {
        super.viewDidDisappear(animated)
        callback?()
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            showUpload()
        }
    }
    
    func showUpload() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])  {
        let pickedImage = info[.originalImage] as! UIImage
         
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/Images/\(fichier.id!).jpg"
        
        let imageData = pickedImage.jpegData(compressionQuality: 10.0)
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
         
        if (fileManager.fileExists(atPath: filePath)){
            self.fichierImg.image = UIImage.init(contentsOfFile: filePath)
        }
         
        picker.dismiss(animated: true, completion:nil)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
