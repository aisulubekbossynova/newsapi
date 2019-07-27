//
//  DetailNewsViewController.swift
//  newsapp
//
//  Created by aisulubekbossynova on 7/24/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class DetailNewsViewController: UIViewController {
    var names = ""
    var imgurl = ""
    
    @IBOutlet weak var imgtit: UIStackView!
    var details = ""
    @IBOutlet weak var descriptionOfNews: UITextView!
    @IBOutlet weak var titleOfNews: UILabel!
    @IBOutlet weak var imgForNews: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionOfNews.text = details
        imgForNews.downloaded(from: imgurl)
        titleOfNews.text = names
        // Do any additional setup after loading the view.
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
