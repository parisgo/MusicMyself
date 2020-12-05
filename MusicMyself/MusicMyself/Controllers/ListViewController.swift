//
//  ListViewController.swift
//  MusicMyself
//
//  Created by XYU on 05/12/2020.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var albums: [Album]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName:"ListCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cellList")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        albums = Album().getList()
        collectionView.reloadData()
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

extension ListViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellList", for: indexPath) as! ListCollectionViewCell
        cell.album = albums[indexPath.row]
        cell.listTitle.text = cell.album.title
        
        return cell
    }
}

extension ListViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let alert = UIAlertController(title: "Test", message: "\(albums[indexPath.row])", preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
        let cell = collectionView.cellForItem(at: indexPath)
        self.performSegue(withIdentifier: "go2ListDetail", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "go2ListDetail" {
                let tmp = segue.destination as! ListDetailViewController
                
                let cell = sender as! ListCollectionViewCell
                let indexPath = self.collectionView.indexPath(for: cell)
                tmp.album = albums[indexPath!.row]
            }
        }
    }  
}
