//
//  VideoViewController.swift
//  SeSACWeek4
//
//  Created by 선상혁 on 2023/08/08.
//

import UIKit

class VideoViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var videoTableView: UITableView!
    
    var videoResult: Video!
    var videoList: [Document] = []
    var page = 1
    var isEnd = false //현재 페이지가 마지막 페이지인지 점검하는 프로퍼티
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoTableView.delegate = self
        videoTableView.dataSource = self
        videoTableView.prefetchDataSource = self
        videoTableView.rowHeight = 140
        
        searchBar.delegate = self
    }
    
    func callRequest(query: String, page: Int) {
       
        KakaoAPIManager.shared.callRequest(type: .video, query: query) { result in
            self.videoResult = result
            self.videoList = result.documents
            self.videoTableView.reloadData()
        }
        
//        //AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                //print("JSON: \(json)")
//
//                print(response.response?.statusCode)
//
//                let statusCode = response.response?.statusCode ?? 500
//
//                if statusCode == 200 {
//
//                    self.isEnd = json["meta"]["is_end"].boolValue
//
//                    for item in json["documents"].arrayValue {
//
//                        let author = item["author"].stringValue
//                        let date = item["datetime"].stringValue
//                        let playTime = item["play_time"].intValue
//                        let thumbNail = item["thumbnail"].stringValue
//                        let title = item["title"].stringValue
//                        let link = item["url"].stringValue
//
//                        let data = Video(author: author, date: date, playtime: playTime, thumbnail: thumbNail, title: title, link: link)
//
//                        self.videoList.append(data)
//                    }
//
//                    self.videoTableView.reloadData()
//
//                } else {
//                    print("다시 시도해주세요!")
//                }
//
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}

extension VideoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        page = 1 //새로운 검색어이기 떄문에 page를 1로 변경
        videoList.removeAll()
        
        guard let query = searchBar.text else {
            return
        }
        callRequest(query: query, page: page)
    }
}

//UITableViewDataSourcePrefetching: iOS10이상 사용 가능 프로토콜
extension VideoViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    //셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운 받는 기능
    //videoList 갯수와 indexPath.row 위치를 비교해 마지막 스크롤 시점을 확인 -> 네트워크 요청 시도
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if videoList.count - 1 == indexPath.row && page < 15 && !videoResult.meta.isEnd {
                page += 1
                callRequest(query: searchBar.text!, page: page)
            }
            
        }
    }
    
    //취소 기능: 직접 취소하는 기능을 구현해주어야 함!
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("====취소: \(indexPaths)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.identifier) as? VideoTableViewCell else {
            return UITableViewCell()
        }
        let row = indexPath.row
        
        cell.configureCell(data: videoList[row])
        
        return cell
    }
}
