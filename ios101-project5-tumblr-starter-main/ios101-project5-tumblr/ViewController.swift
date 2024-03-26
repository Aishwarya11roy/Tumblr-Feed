//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell // Assuming your cell's identifier is "PostCell"
               let post = posts[indexPath.row]
               
        cell.overviewLabel.text = post.summary // Assuming you have a UILabel with the identifier summaryLabel
               
               if let photo = post.photos.first {
                   Nuke.loadImage(with: photo.originalSize.url, into: cell.posterImageView) // Assuming you have a UIImageView with the identifier photoImageView
               }
               
               return cell
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    // Array to store the fetched blog posts
        var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

        
        fetchPosts()
    }
    
    


    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)
                           DispatchQueue.main.async {
                               self.posts = blog.response.posts
                               print("Fetched \(self.posts.count ?? 0) posts")
                               self.tableView.reloadData()
                }
            } catch {
                // Handle JSON decoding error appropriately for your app
                print("Error decoding JSON: \(error)")
            }
        }
        session.resume()
    }
}
