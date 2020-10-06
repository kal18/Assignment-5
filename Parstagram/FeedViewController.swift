//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Kimberly Le on 10/4/20.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var posts = [PFObject]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //steps
        //1 making and getting the query
        let query = PFQuery(className:"Posts")
        //this adds the reference instead of the pointer
        query.includeKey("author")
        //setting up a limit
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in //2 store the data
            if posts != nil
            {
                self.posts = posts! //put the posts into array
                self.tableView.reloadData() //3 reload table view
            
                
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //grab the posts
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = posts[indexPath.row]
        
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username
        
        cell.captionLabel.text = (post["caption"] as! String)
        
        //grabbing image URL
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string : urlString)!
        
        cell.photoView.af.setImage(withURL: url)
        
        return cell
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
