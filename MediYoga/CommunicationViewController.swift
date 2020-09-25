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
        self.navigationItem.setHidesBackButton(true, animated: true)

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "CommunicationChatViewController") as! CommunicationChatViewController

        performSegue(withIdentifier: "segue", sender: self)



    }
    
}
