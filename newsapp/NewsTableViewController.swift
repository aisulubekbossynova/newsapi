//
//  NewsTableViewController.swift
//  newsapp
//
//  Created by aisulubekbossynova on 7/24/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import CoreData
class NewsTableViewController: UITableViewController {
    var rowname = ""
    var items2 = 0
    var titles = [String:String]()
    var limit = 20
    var index = 0
    var page = 1
    var totalentries = 0
    var titlenews = ""
    var des = ""
    var descriptions = [String]()
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        //TODO: При протягивании вниз (swipe) данные должны быть обновлены.
        apiwork()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshControl.addTarget(self, action: Selector("refresh:"), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        apiwork()
        index = titles.count
        print(titles)
        
    }
    func apiwork(){
        //TODO: Do api work
        let newsapi = "https://newsapi.org/v2/everything?q=billie&page=\(page)&from=2019-06-27&sortBy=publishedAt&apiKey=f6ef2171d71e4cb59c60ef365b433d0d"
        let url = NSURL(string: newsapi)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let manageContent = appDelegate.persistentContainer.viewContext
        
        let newsEntity = NSEntityDescription.entity(forEntityName: "Newsmodel", in: manageContent)!
        
        let news = NSManagedObject(entity: newsEntity, insertInto: manageContent)
        
        // Create your request
        let task = URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) -> Void in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                  //  print("Response from news: \(jsonResult)")
//                    self.items2 = self.limit
                   // self.totalentries = 20
                    self.totalentries = jsonResult["totalResults"] as! Int
                    if let items = jsonResult["articles"] as? [AnyObject]{
                    
                        for i in 0..<20{
                            print("getting\(i)th element")
                           // self.index += 1
                            let title = items[i]["title"] as! String
                            self.descriptions.append(items[i]["description"] as! String)
                            // let hh = items[i]["snippet"] as AnyObject
                            var urlimg = items[i]["urlToImage"] as? String
                            if urlimg != nil{
                                urlimg = items[i]["urlToImage"] as! String
                            }
                            else{
                                urlimg = "https://clipart.wpblink.com/sites/default/files/wallpaper/drawn-potato/344733/drawn-potato-kowaii-344733-9770651.jpg"
                            }
//                            if let hey = items[i]["urlToImage"] {
//                                urlimg = hey as! String
//                            }
//                            else{
//                                urlimg = "https://clipart.wpblink.com/sites/default/files/wallpaper/drawn-potato/344733/drawn-potato-kowaii-344733-9770651.jpg"
//                            }
                            self.titles[urlimg!] = title
                            news.setValue(title, forKeyPath: "title")
                            news.setValue(urlimg!, forKeyPath: "image")
                            news.setValue(self.descriptions[i], forKeyPath: "descript")
                            do{
                                try manageContent.save()
                            }catch let error as NSError {
                                
                                print("could not save . \(error), \(error.userInfo)")
                            }
                            
                        }
                    }
                    print(self.titles)
                }
            }
            catch {
                print("json error: \(error)")
            }
            
        })
        task.resume()
   
    }

    
    func fetchData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageContent = appDelegate.persistentContainer.viewContext
        let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: "Newsmodel")
        
        do {
            
            let result = try manageContent.fetch(fetchData)
            
            for data in result as! [NSManagedObject]{
                
                print(data.value(forKeyPath: "title") as! String)
                print(data.value(forKeyPath: "image") as! String)
                print(data.value(forKeyPath: "descript") as! String)

            }
        }catch {
            print("err")
        }
    }

    // MARK: - Table view data source
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.stoppedScrolling()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.stoppedScrolling()
        }
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == titles.count - 1 {
            // we are at last cell load more content
            if titles.count < totalentries {
                // we need to bring more records as there are some pending records available
                index = titles.count
                if totalentries - limit > 20{
                    if page < 5{
                    page += 1
                    limit = index + 20
                    apiwork()
                        self.perform(#selector(loadTable), with: nil, afterDelay: 1.0)
                        
                    }
                    
                }
            }
        }
    }
    
    @objc func loadTable() {
        self.tableView.reloadData()
    }
    func stoppedScrolling() {
//        apiwork()
//        tableView.reloadData()
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142.5
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if titles.count > 0{
            return titles.count}
        else{
            NewsTableViewController.EmptyMessage(message: "Pull the window down, to get the news.", viewController: self)
            return 0
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ident", for: indexPath) as! NewsTableViewCell
//        if cell == nil {
//            cell = UITableViewCell(style: .default, reuseIdentifier: "ident") as! NewsTableViewCell
//        }
  
        if titles.count > 0{
        cell.vidlbl.text = Array(titles.values)[indexPath.row]
//        let imageURL: URL = URL(string: Array(titles.keys)[indexPath.row])!
//        let queue = DispatchQueue.global(qos: .utility)
//        queue.async{
//            if let data = try? Data(contentsOf: imageURL){
//                DispatchQueue.main.async {
//                    cell.vidimg.image = UIImage(data: data)
//                    print("Show image")
//                }
//                print("Did download image ")
//            }
//        }
        cell.vidimg.downloaded(from: Array(titles.keys)[indexPath.row])
        
        }
        else{
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let manageContent = appDelegate!.persistentContainer.viewContext
            let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: "Newsmodel")
            do {
             let result = try manageContent.fetch(fetchData)
                
                for data in result as! [NSManagedObject]{
                    
                    cell.vidlbl.text = data.value(forKeyPath: "title") as! String
                    cell.vidimg.downloaded(from: data.value(forKeyPath: "image") as! String)
                    // print(data.value(forKeyPath: "descript") as! String)
                    
                }
            }catch {
                cell.vidlbl.text = "Receiving data"

            }
        }
        
        return cell
    }
    
    class func EmptyMessage(message:String, viewController:UITableViewController) {
        
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width:
            viewController.view.bounds.size.width, height: viewController.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        viewController.tableView.backgroundView = messageLabel;
        viewController.tableView.separatorStyle = .none;
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return false
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowname = Array(titles.values)[indexPath.row]
        titlenews = Array(titles.keys)[indexPath.row]
        des = descriptions[indexPath.row]
        performSegue(withIdentifier: "cellclicked", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellclicked"{
            var dest = segue.destination as? DetailNewsViewController
            dest?.names = rowname
            dest?.imgurl = titlenews
            dest?.details = des
        }

    }
    
    
}

extension Dictionary where Value: Equatable {
    func allKeys(forValue val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
