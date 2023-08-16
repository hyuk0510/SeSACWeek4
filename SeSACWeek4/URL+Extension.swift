//
//  URL+Extension.swift
//  SeSACWeek4
//
//  Created by 선상혁 on 2023/08/11.
//

import Foundation

extension URL {
    static let baseURL = "https://dapi.kakao.com/v2/search/"
    
    static func makeEndPointString(_ endpoint: String) -> String {
        return baseURL + endpoint
    }
}
