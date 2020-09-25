//
//  ViewControllertest.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 24/09/20.
//

import UIKit

class ViewControllertest: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func action(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(identifier: "ViewControllertest2") as! ViewControllertest2
        self.navigationController?.pushViewController(vc, animated: true)

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
