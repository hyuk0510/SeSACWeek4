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

    @IBOutlet var movieTableView: UITableView!
    
    var movieList: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        
        movieTableView.rowHeight = 60
        
        callRequest()
    }

    // .ipa  .app
    
    func callRequest() {
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOffice)&targetDt=20120101"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for item in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    let name = item["movieNm"].stringValue
                    let openDt = item["openDt"].stringValue
                    
                    self.movieList.append(Movie(movieName: name, openDate: openDt))
                }
                
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
