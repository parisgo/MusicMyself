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
    
    var fichiers: [Fichier]!
    var callback : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    
        let nib = UINib(nibName:"ListAlbumTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidDisappear(_ animated : Bool) {
        super.viewDidDisappear(animated)
        callback?()
    }
    
    @IBAction func addClick(_ sender: Any) {
        if let _text = txtTitle.text, _text.isEmpty {
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
        return (fichiers != nil) ? fichiers.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListAlbumTableViewCell
        cell?.fichier = fichiers[indexPath.row]
        
        if let delButton = cell?.contentView.viewWithTag(2) as? UIButton {
            delButton.addTarget(self, action: #selector(deleteFileClick(_ :)), for: .touchUpInside)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    @objc func deleteFileClick(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        self.fichiers.remove(at: indexPath!.row)
        
        self.tableView.reloadData()
    }
}
