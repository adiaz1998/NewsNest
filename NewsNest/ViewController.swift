//
//  ViewController.swift
//  NewsNest
//
//  Created by Alan Díaz on 12/7/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    
    
    //Intialize array containing all of the articles
    var articles: [NewsArticle]? = []
    var category = "general"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        
        retrieveArticles(fromSource: category)
        
    }
    
    func retrieveArticles(fromSource category: String){
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=\(category)&apiKey=21934fcafea34b6893d04a181838da92")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            // Create an empty Articles array
            self.articles = [NewsArticle]()
            do{
                // Converts JSON into dictionary format
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                    
                if let articlesDict = json["articles"] as? [[String : AnyObject]] {
                    for articlesDict in articlesDict {
                        let article = NewsArticle()
                        if let title = articlesDict["title"] as? String, let author = articlesDict["author"] as? String, let desc = articlesDict["description"] as? String, let url = articlesDict["url"] as? String, let urlToImage = articlesDict["urlToImage"] as? String {
                                                            
                            article.author = author
                            article.desc = desc
                            article.headline = title
                            article.url = url
                            article.imageUrl = urlToImage
                            
                            self.articles?.append(article)

                        }
                        
                        
                    }
                            
                }
                // Reload table after the for loop has been completed
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
                
                
            } catch let error {
                    print(error)
                }
            }
            
        task.resume()
        
        
        }
    
    func numberOfSections(in table: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! NewsArticleCell
        
        
        cell.title.text = self.articles?[indexPath.item].headline
        cell.desc.text = self.articles?[indexPath.item].desc
        cell.author.text = self.articles?[indexPath.item].author
        if self.articles?[indexPath.item].imageUrl != nil{
            cell.imgView.downloadImg(from: (self.articles?[indexPath.item].imageUrl!)!)
        }
        return cell
    }
    
    
    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If the length of the articles array is null, then return 0
        return self.articles?.count ?? 0
    }
    
    let menuSelection = MenuSelection()
    @IBAction func pressMenu(_ sender: Any) {
        menuSelection.displayMenu()
        menuSelection.mainVC = self
    }
    
    func handleMenuButton(){
        //Display Menu
        let blackView = UIView()
        blackView.backgroundColor = UIColor.black
        self.view.addSubview(blackView)
        blackView.frame = self.view.frame
    }

}

extension UIImageView {
    
    func downloadImg(from url: String){
       
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) in
            if error != nil{
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
    
}
