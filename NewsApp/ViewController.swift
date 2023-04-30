//
//  ViewController.swift
//  NewsApp
//
//  Created by Ebuzer Şimşek on 23.04.2023.
//
import UIKit
import SafariServices

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var authorArray      = [String]()
    var explanationArray = [String]()
    var urlToImageArray  = [String]()
    var articleArray     = [Any]()
    var urlArray         = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate   = self
        title = "News"
        
        
        
        // API CALLING
        
        
        let urlstring = "https://newsapi.org/v2/everything?q=bitcoin&apiKey=d0f416d686d848d493393e22075f0b65"
        if let url = URL(string: urlstring) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error?.localizedDescription ?? "Error")
                }
                else {
                    if let data = data {
                        do{
                            if let jsonResponse = try JSONSerialization.jsonObject(with: data,options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] {
                                if let articles = jsonResponse["articles"] as? [[String:Any]] {
                                    for article in articles {
                                        if let author = article["title"] as? String {
                                            self.authorArray.append(author)
                                            self.articleArray.append(articles)
                                            
                                        }
                                    }
                                    if let articles = jsonResponse["articles"] as? [[String:Any]] {
                                        for article in articles {
                                            if let explanation = article["description"] as? String {
                                                self.explanationArray.append(explanation)
                                            }
                                        }
                                        
                                        if let articles = jsonResponse["articles"] as? [[String:Any]] {
                                            for article in articles {
                                                if let URL = article["url"] as? String {
                                                    self.urlArray.append(URL)
                                                }
                                            }
                                            
                                            if let articles = jsonResponse["articles"] as? [[String:Any]] {
                                                for article in articles {
                                                    if let imageUrl = article["urlToImage"] as? String {
                                                        self.urlToImageArray.append(imageUrl)
                                                    }
                                                    
                                                }
                                            }
                                            
                                            // Yeni veriler geldiğinde tabloyu yenile
                                            DispatchQueue.main.async {
                                                self.tableView.reloadData()
                                            }
                                        }
                                    }
                                }
                            }
                            } catch {
                            print("failed")
                        }
                     }
                 }
             }
            task.resume()
        }
     }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
//    CELL
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authorArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsCell
        cell.newsExplanation.numberOfLines = 4
        cell.newsExplanation.text = explanationArray[indexPath.row]
        cell.newsExplanation.font = UIFont.systemFont(ofSize: 16)
        cell.headLabel.font = UIFont.boldSystemFont(ofSize: 22)
        cell.headLabel.numberOfLines = 2
        cell.headLabel.text = self.authorArray[indexPath.row]
        cell.CustomImageView.clipsToBounds = true
        cell.CustomImageView.contentMode = .scaleAspectFill
     
        loadImage(from: urlToImageArray[indexPath.row]) { image in
            DispatchQueue.main.async {
                cell.CustomImageView.image = image
            }
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articleArray[indexPath.row]
        guard let url = URL(string: urlArray[indexPath.row]) else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc,animated: true)
    }
}
