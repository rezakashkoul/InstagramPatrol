//
//NetworkManager.swift
//  patInsta
//
//  Created by Reza Kashkoul on 23-Esfand-1400 .
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

class NetworkManager {
    
    let disposeBag = DisposeBag()
    static let shared = NetworkManager()
    
    func searchUser(userName: String) {
        
        let url = "https://www.instagram.com/web/search/topsearch/?context=blended&query=\(userName)&rank_token=0.03148428025826622&include_reel=true"
        let headers = [ "Cookie" : cookie ,
                        "Accept" : "*/*",
                        "Accept-Language" : "en-US,en;q=0.9",
                        "Accept-Encoding" : "gzip, deflate, br",
                        "Host" : "www.instagram.com",
                        "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Safari/605.1.15",
                        "Connection" : " keep-alive",
                        "Referer" : " https://www.instagram.com/",
                        "X-ASBD-ID" : "198387",
                        "X-Requested-With" : "XMLHttpRequest",
                        "X-IG-App-ID" : "936619743392459",
                        "X-IG-WWW-Claim" : "hmac.AR3L09VMpCg0OPafUJ2I1ohvcQa01YecAxjUVx7sWbBlHLz9"
        ]
        
        AF.request(url, method: .get, headers: HTTPHeaders(headers)).responseJSON { result in
            print(result.data!)
            let decoder = JSONDecoder()
            do {
                let myData = try decoder.decode(UserData.self, from: result.data!)
                print(myData.users)
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
}


