//
//  FirstViewController.swift
//  TestNavigationController
//
//  Created by XYU on 06/12/2020.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var btnFirstDetail: UIButton!
    
    @IBAction func btnFristDetailClick(_ sender: Any) {
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "firstDetail") {
            //present(controller, animated: true, completion: nil)
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
