//
//  KakaoAPIManager.swift
//  SeSACWeek4
//
//  Created by 선상혁 on 2023/08/11.
//

import Foundation
import Alamofire
import SwiftyJSON

class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    
    private init() { }
    
    let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakaoSearch)"]
    
    func callRequest(type: Endpoint, query: String, completionHandler: @escaping (Video) -> Void ) {
        
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = type.requestURL + text
        
        AF.request(url, method: .get, headers: header).validate().responseDecodable(of: Video.self) { response in
            
            guard let value = response.value else { return }
            
            completionHandler(value)
            
        }
    }
}
