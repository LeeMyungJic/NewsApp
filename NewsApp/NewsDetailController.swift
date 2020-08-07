//
//  NewsDetailController.swift
//  TableView
//
//  Created by 이명직 on 2020/08/07.
//  Copyright © 2020 LMJ. All rights reserved.
//

import UIKit

class NewsDetailController: UIViewController {
    
    
    @IBOutlet weak var ImageMain: UIImageView!
    @IBOutlet weak var LabelMain: UILabel!
    var imageURL: String?
    var desc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let img = imageURL {
            // data 사용하여 이미지 가져오기
            if let data = try? Data(contentsOf: URL(string: img)!) {
                DispatchQueue.main.async {
                    self.ImageMain.image = UIImage(data: data
                    )
                }
            }
        }
        
        if let d = desc {
            self.LabelMain.text = d
        }
    }
}
