//
//  ListAlbumViewController.swift
//  MusicMyself
//
//  Created by XYU on 08/12/2020.
//

import UIKit

class ListAlbumViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtTitle: UITextField!
    
    var fichiers: [Fichier] = []
    var callback : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    
        let nib = UINib(nibName:"FichierTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        txtTitle.addBottomBorder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated : Bool) {
        super.viewDidDisappear(animated)       
        
        callback?()
    }
    
    @IBAction func addClick(_ sender: Any) {
        if let _text = txtTitle.text, _text.isEmpty {
            return
        }
        
        if Album().isExist(title: txtTitle.text!.trim()) {
            let alert = UIAlertController(title: "Add playlist", message: "Playlist exist", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in })
            alert.addAction(ok)
            DispatchQueue.main.async(execute: {self.present(alert, animated: true)})
            
            return
        }
        
        let album = Album(title: txtTitle.text!)
        let fileIds = fichiers.map{ $0.id!}
        
        Album().add(album: album, fileIds: fileIds)
        
        callback?()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFileClick(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ListAlbumSelectViewController") {
            let tmp = controller as! ListAlbumSelectViewController
            tmp.callback = {
                if tmp.fichierSelect.count > 0 {
                    self.fichiers = Array(tmp.fichierSelect)
                    self.tableView.reloadData()
                }
            }
            
            //self.navigationController?.pushViewController(tmp, animated: true)
            present(tmp, animated: true, completion: nil)
        }
    }
}

extension ListAlbumViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fichiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FichierTableViewCell
        cell?.fichier = fichiers[indexPath.row]
        
//        if let delButton = cell?.contentView.viewWithTag(2) as? UIButton {
//            delButton.addTarget(self, action: #selector(deleteFileClick(_ :)), for: .touchUpInside)
//        }
        
        if(indexPath.row % 2 == 0) {
            cell?.backgroundColor = .systemGray6            
        }
        else {
            cell?.backgroundColor = .none
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            self.fichiers.remove(at: indexPath.row)
            self.tableView.reloadData()
            
            completionHandler(true)
        }
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        
        return swipeActionConfig
    }
    
    @objc func deleteFileClick(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        self.fichiers.remove(at: indexPath!.row)
        
        self.tableView.reloadData()
    }
}
