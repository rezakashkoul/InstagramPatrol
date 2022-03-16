//
//  UserViewController.swift
//  patInsta
//
//  Created by Reza Kashkoul on 24-Esfand-1400 .
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire

class UserViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    var selectedUser: UserElement? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
//        loadUsersData()

    }
    
//    func loadUsersData() {
//        if let data = UserDefaults.standard.data(forKey: "user") {
//            do {
//                let decoder = JSONDecoder()
//                selectedUsers = try decoder.decode([UserElement].self, from: data)
//            } catch {
//                print("Unable to Decode userData (\(error))")
//            }
//        }
//    }
    
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        cell.userNameLabel.text = userList?[indexPath.row].user.username
        let url = URL(string: userList?[indexPath.row].user.profilePicURL ?? "")
        do {
            DispatchQueue.main.async {
                let data = try? Data(contentsOf: url!)
                cell.profileImage.image = UIImage(data: data!)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(selectedUser)
        searchFollwers(pk: "648591872")
//        searchFollwers(pk: (selectedUser?.user.pk)!)
    }
    
    
}

extension UserViewController {
    
    func searchFollwers(pk: String = "648591872") {
        
        let url = "https://i.instagram.com/api/v1/friendships/648591872/followers/?count=12&max_id=100&search_surface=follow_list_page"
        
//        let url = "https://i.instagram.com/api/v1/friendships/648591872/followers/?count=12&max_id=100&search_surface=follow_list_page"
//
        
        let headers = [
            "Accept" : "*/*",
            "Accept-Encoding" : "gzip, deflate, br",
            "Accept-Language" : "en-US,en;q=0.9",
            "Host" : "www.instagram.com",
            "Origin":"https://www.instagram.com",
            "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.3 Safari/605.1.15",
            "Connection" : " keep-alive",
            "Referer" : " https://www.instagram.com/",
            "Cookie" : cookie ,
            "X-ASBD-ID" : "198387",
            "X-IG-App-ID" : "936619743392459",
            "X-IG-WWW-Claim" : "hmac.AR3i_Zolo-GMNQQS8xA13FHD-XmcSMC_9smGx7qgDDv1gznF"
        ]
        
        RxAlamofire.requestData(.get, url, headers: HTTPHeaders(headers))
            .subscribe(onNext: { [weak self] (response, json) in
                guard let self = self else { return }
                do {
                    let userData = try JSONDecoder().decode(UserFollowers.self, from: json)
                    followerList = userData
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("***** error in parse data")
                    print(error.localizedDescription)
                }
            }, onError: {(error) in
                print("***** error in OnError",error)
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
        
    }
}
