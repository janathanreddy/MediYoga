//
//  ChattingCommViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 28/09/20.
//

import UIKit

class ChattingCommViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField_1: UITextField!
    @IBOutlet weak var label_1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        textField_1.layer.cornerRadius = 15.0
        textField_1.layer.borderWidth = 2.0
        textField_1.layer.borderColor = UIColor.black.cgColor
        textField_1.alpha = 0.6

    }
    
    @IBAction func backsegue(_ sender: Any) {
        
    }
    @IBAction func callbtn(_ sender: Any) {
        
    }
    
    @IBAction func camerabtn(_ sender: Any) {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
    }

}
