//
//  AdminCommunicationViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit

class AdminCommunicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   

    @IBOutlet weak var tableView: UITableView!
    var image:[String] = ["33.jpg"]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AdminCommunicationTableViewCell
        cell.imagechat.image = UIImage(named: image[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "AdminSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AdminSegue" {
            let VC:AdminComViewController = segue.destination as! AdminComViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            VC.GroupName = "Admin Group"
            VC.GroupImage = image[indexPath!.row]

        }

                }

}
