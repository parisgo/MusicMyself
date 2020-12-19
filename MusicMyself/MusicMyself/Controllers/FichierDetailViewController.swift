//
//  FichierDetailViewController.swift
//  MusicMyself
//
//  Created by XYU on 05/12/2020.
//

import UIKit

class FichierDetailViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var fichierImg: UIImageView!
    @IBOutlet weak var fichierTitle: UITextField!
    @IBOutlet weak var fichierAuthor: UITextField!
    @IBOutlet weak var fichierDetail: UITextView!
    
    var fichier: Fichier!
    
    var callback : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fichierTitle.delegate = self
        fichierAuthor.delegate = self
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        fichierImg.addGestureRecognizer(tapGR)
        fichierImg.isUserInteractionEnabled = true
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if let file = Fichier().get(id: fichier.id) {
            fichierTitle.text = file.title
            fichierAuthor.text = file.author
            fichierDetail.text = file.info
        }
        
        fichierImg.image = Helper.getImage(id: fichier.id)
    }
    
    override func viewDidDisappear(_ animated : Bool) {
        super.viewDidDisappear(animated)
        callback?()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            showUpload()
        }
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        print("keyboard will show: \(notification.name.rawValue)")
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            view.frame.origin.y = -keyboardRect.height
        }
        if notification.name == UIResponder.keyboardWillHideNotification {
            view.frame.origin.y = 0
        }
    }
    
    @IBAction func doneClick(_ sender: Any) {
        fichier.title = fichierTitle.text
        fichier.author = fichierAuthor.text
        fichier.info = fichierDetail.text
        
        Fichier().update(fichier: fichier)
        
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FichierDetailViewController: UIImagePickerControllerDelegate {
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
}

extension FichierDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }
}
