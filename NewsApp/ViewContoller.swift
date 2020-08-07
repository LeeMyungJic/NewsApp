//
//  ViewController.swift
//  TableView
//
//  Created by 이명직 on 2020/08/04.
//  Copyright © 2020 LMJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var TableViewMain: UITableView!
    
    var newsdata :Array<Dictionary<String, Any>>?
    
    func getNews() {
        let task = URLSession.shared.dataTask(with: URL(string: "API")!) { (data, response, error) in
            
            if let dataJson = data {
                
                do {
                    // JSONSerialization로 데이터 변환하기
                    let json = try JSONSerialization.jsonObject(with: dataJson, options: []) as! Dictionary<String, Any>
                    
                    let articles = json["articles"] as! Array<Dictionary<String, Any>>
                    
                    self.newsdata = articles
                    
                    
                    // UI부분이니까 백그라운드 말고 메인에서 실행되도록 !
                    DispatchQueue.main.async {
                        //reloadData로 데이터를 가져왔으니 쓰라고 통보 ㅎㅎ
                        self.TableViewMain.reloadData()
                    }
                    
//                    for (idx, value) in articles.enumerated() {
//                        if let v = value as? Dictionary<String, Any> {
//                            print("\(v["title"])")
//                        }
//                    }
                }
                catch {
                    
                }
                // Json Parsing
            }
        }
        task.resume()
    }
    
    // 데이터가 몇 개인지
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let news = newsdata {
            return news.count
        }
        else {
            return 0
        }
    }
    
    // 데이터가 무엇인지
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 셀을 임의로 생성하는 함수
//        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "TableCellType1")
        
        let cell = TableViewMain.dequeueReusableCell(withIdentifier: "Type1", for: indexPath) as! Type1
        
        let idx = indexPath.row
        if let news = newsdata {
            let row = news[idx]
            if let r = row  as? Dictionary<String, Any> {
                if let title = r["title"] as? String{
                    cell.LabelText.text = title
                }
            }
        }
        
        // 데이터 인덱스를 텍스트 라벨에 출력
        //cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
    
    // 아이템 클릭 이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "NewsDetailController") as! NewsDetailController

        if let news = newsdata {
            let row = news[indexPath.row]
            if let r = row as? Dictionary<String, Any> {
                if let imageUrl = r["urlToImage"] as? String {
                    controller.imageURL = imageUrl
                }
                if let desc = r["description"] as? String {
                    controller.desc = desc
                }
            }
        }
        // 이동을 수동으로
        //showDetailViewController(controller, sender: nil)
        
    }
    
    // 이어지기 전에 먼저 데이터를 준비 (자동)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, "NewsDetail" == id {
            if let controller = segue.destination as? NewsDetailController {
                if let news = newsdata {
                    if let indexPath = TableViewMain.indexPathForSelectedRow {
                    let row = news[indexPath.row]
                    
                    if let r = row as? Dictionary<String, Any> {
                        if let imageUrl = r["urlToImage"] as? String {
                            controller.imageURL = imageUrl
                        }
                        if let decs = r["description"] as? String {
                            controller.desc = decs
                        }
                    }
                }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        TableViewMain.delegate = self
        TableViewMain.dataSource = self
        
        getNews()
    }


}

