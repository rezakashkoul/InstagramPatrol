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
    var selectedUsers: [UserElement]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        loadUsersData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let userName = userName else { return }
        getUserProfile(userName: userName)
    }
    
    func saveUsersData(userData: [UserElement]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(selectedUsers)
            UserDefaults.standard.set(data, forKey: "userMemory")
        } catch {
            print("Unable to Encode userData (\(error.localizedDescription))")
        }
    }
    
    func loadUsersData() {
        if let data = UserDefaults.standard.data(forKey: "userMemory") {
            do {
                let decoder = JSONDecoder()
                selectedUsers = try decoder.decode([UserElement].self, from: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Unable to Decode userData (\(error))")
            }
        }
    }
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedUsers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        cell.userNameLabel.text = selectedUsers?[indexPath.row].user.username
        cell.totalFollowerLabel.text = "Total Followers:" + " " + (userFollowerCount?.description ?? "")
        cell.loadedFollowerLabel.text = "Its loading..."
        let url = URL(string: selectedUsers?[indexPath.row].user.profilePicURL ?? "")
        do {
            DispatchQueue.global(qos: .background).async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    if let data = data {
                        cell.profileImage.image = UIImage(data: data)
                    }
                }
            }

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pk = selectedUsers?[indexPath.row].user.pk else { return }
        searchFollwers(pk: pk)
        print("user pk is ",pk)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
          print("Deleted")
          loadUsersData()
          self.selectedUsers?.remove(at: indexPath.row)
          saveUsersData(userData: self.selectedUsers!)
          self.tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
    
    
}

extension UserViewController {
    
    func searchFollwers(pk: String) {
        
        let url = "https://i.instagram.com/api/v1/friendships/648591872/followers/?count=100&max_id=100&search_surface=follow_list_page"
        
        let headers = [
            "Accept" : "*/*",
            "Accept-Encoding" : "gzip, deflate, br",
            "Accept-Language" : "en-US,en;q=0.9",
            "Host" : "i.instagram.com",
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
                    let decoder = JSONDecoder()
                    let userData = try decoder.decode(UserFollowers.self, from: json)
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


extension UserViewController {
    
    func getUserProfile(userName: String) {
        
        let url = "https://www.instagram.com/\(userName)/?__a=1&__d=dis"
        
        let headers = [
            "Accept" : "*/*",
            "Accept-Language" : "en-US,en;q=0.9",
            "Accept-Encoding" : "gzip, deflate, br",
            "Host" : "www.instagram.com",
            "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.3 Safari/605.1.15",
            "Connection" : " keep-alive",
            "Referer" : "https://www.instagram.com/\(userName)/",
            "Cookie" : cookie ,
            "X-ASBD-ID" : "198387",
            "X-Requested-With":"XMLHttpRequest",
            "X-IG-App-ID" : "936619743392459",
            "X-IG-WWW-Claim" : "hmac.AR2YgqsTVBo4dOn5nhwrI9RM8-vz2c-0fgyMQe2oHZZ7ScCD"
        ]
        
        RxAlamofire.requestData(.get, url, headers: HTTPHeaders(headers))
            .subscribe(onNext: { [weak self] (response, json) in
                guard let self = self else { return }
                do {
                    let decoder = JSONDecoder()
                    let userData = try decoder.decode(UserProfile.self, from: json)
                    userFollowerCount = userData.graphql.user.edge_followed_by.count
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
