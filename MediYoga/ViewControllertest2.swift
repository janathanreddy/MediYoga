//
//  ViewControllertest2.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 24/09/20.
//

import UIKit

class ViewControllertest2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    @IBAction func action(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(identifier: "ViewControllertest") as! ViewControllertest
        self.navigationController?.pushViewController(vc, animated: true)

    }
    

}
