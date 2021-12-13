//
//  MenuSelection.swift
//  NewsNest
//
//  Created by Alan Díaz on 12/11/21.
//

import UIKit

class MenuSelection: NSObject, UITableViewDelegate, UITableViewDataSource {
    //Display Menu programmatically
    let blackView = UIView()
    let menuTableView = UITableView()
    let categoryList = ["science", "health", "technology", "sports", "business", "entertainment"]
    var mainVC: ViewController?
    
    public func displayMenu(){
        //The whole window from the app delegate
        if let window = UIApplication.shared.keyWindow{
            blackView.frame = window.frame
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeMenu)))
            
            let height: CGFloat = 250
            
            // Place the tables at the bottom of the frame
            let y = window.frame.height - height
            
            menuTableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            window.addSubview(blackView)
            window.addSubview(menuTableView)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.blackView.alpha = 1
                // Slide it out
                self.menuTableView.frame.origin.y = y

            })
        
        }
    }
    
    @objc func closeMenu(){
        UIView.animate(withDuration: 0.5, animations:
                        {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.menuTableView.frame.origin.y = window.frame.height
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as UITableViewCell
        cell.textLabel?.text = categoryList[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = mainVC as? ViewController {
            vc.category = categoryList[indexPath.item]
            vc.retrieveArticles(fromSource: categoryList[indexPath.item])
            closeMenu()
        }
    }
    
    override init() {
        super.init()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.isSpringLoaded = false
        menuTableView.bounces = false
        menuTableView.register(BaseViewCell.classForCoder(), forCellReuseIdentifier: "cellId")
    }
    
}
