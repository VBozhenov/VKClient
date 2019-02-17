//
//  NewsController.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 17/01/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit

class NewsController: UITableViewController {
    
    let news = News()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.newsTexts.count
    }

    let newsCollectionCell = NewsCollectionViewController()

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "News", for: indexPath) as! NewsCell
        NewsCollectionViewController.newsNumber = indexPath.row
        cell.newsText?.text = nil
        cell.newsText.text = news.newsTexts[indexPath.row]
        cell.newsFotoCollection?.dataSource = nil
        cell.newsFotoCollection.dataSource = newsCollectionCell
        tableView.rowHeight = cell.newsText.frame.size.height + cell.newsFotoCollection.frame.size.height * 1.5
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show News Image" {
            let newsController = segue.destination as! DetailedNewsController
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                newsController.foto = news.newsImages[indexPath.row]
            }
        }
    }
}
