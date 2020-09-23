//
//  CommunicationViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit

class CommunicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var image:[String] = ["35","36","37","38","39","40"]
    var name:[String] = ["Roamanson","Jonny","Anderson","BikiDev","Assik","Kaamil"]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return image.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommunicationTableViewCell
        cell.chatimage.image = UIImage(named: image[indexPath.row])
        cell.nameField.text = name[indexPath.row]
        return cell
        
    }
    
}
