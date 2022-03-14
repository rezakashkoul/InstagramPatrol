//
//  SearchViewController.swift
//  patInsta
//
//  Created by Reza Kashkoul on 23-Esfand-1400 .
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var cookie = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLogin()
        title = "Search for users"
//        tableView.delegate = self
//        tableView.dataSource = self
    }
    
    func showLogin() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        vc?.modalPresentationStyle = .fullScreen
        vc?.delegate = self
        present(vc!, animated: true, completion: nil)
    }
    
    
}


extension SearchViewController: LoginViewControllerDelegate {
    
    func setCookie(cookie: String) {
        self.cookie = cookie
    }
}

//extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//}
