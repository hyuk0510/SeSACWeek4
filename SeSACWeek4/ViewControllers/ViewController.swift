//
//  ViewController.swift
//  SeSACWeek4
//
//  Created by 선상혁 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Movie {
    var movieName: String
    var openDate: String
}

class ViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var movieTableView: UITableView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    var movieList: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.rowHeight = 60
        
        searchBar.delegate = self
        
        indicatorView.isHidden = true
    }

    // .ipa  .app
    
    func callRequest(date: String) {
        
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOffice)&targetDt=\(date)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for item in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    let name = item["movieNm"].stringValue
                    let openDt = item["openDt"].stringValue
                    
                    self.movieList.append(Movie(movieName: name, openDate: openDt))
                }
                
                self.indicatorView.stopAnimating()
                self.indicatorView.isHidden = true
                self.movieTableView.reloadData()
            
            case .failure(let error):
                print(error)
            }
        }
        
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell")!
        cell.textLabel?.text = movieList[indexPath.row].movieName
        cell.detailTextLabel?.text = movieList[indexPath.row].openDate
        
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        
        //20220101 > 1. 8글자 2. 20233333 올바른 날짜 3. 날짜 범주
        callRequest(date: text)
    }
}
