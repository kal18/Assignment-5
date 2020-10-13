//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Kimberly Le on 10/4/20.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

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
        query.includeKeys(["author", "comments", "comments.author"])
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
            let post = posts[section]
            let comments = (post["comments"] as? [PFObject]) ?? [] //whatever is on the left of question marks, it will be nil as default
            
         
            return comments.count + 1
    }
    
    //giving each post its own section and each section has a however many rows
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    //giving each post its own section and each section has a however many rows
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //grab the posts
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? [] //whatever is on the left of question marks, it will be nil as default

        if indexPath.row == 0 //if the indexPath.row is 0, it's def a postCell
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            
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
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user.username
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let comment = PFObject(className: "Comments") //will auto create comments
        comment["text"] = "This is a random comment"
        comment["post"] = post //let the comment know which post it belongs to
        comment["author"] = PFUser.current()! //who made the comment
        
        post.add(comment, forKey: "comments") //every post should have an array called comments and you are adding the comment into this array
        
        post.saveInBackground { (success, error) in
            if success{
                print("Comment saved")
            }
            else{
                print("Error saving comment")
            }
        }
        
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        
        PFUser.logOut() //clear parse cache which is how we are not logged in anymore
        let main = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        //accessing the window from theapp delegate
        //this is the one object that exists for each app
        UIApplication.shared.delegate as! AppDelegate
        
        
//        let delegate = UIApplication.shared.delegate as! AppDelegate
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate
          else {
            return
          }//assigning a name to this
        //now we can access the delegate to change the window to loginViewController
        delegate.window?.rootViewController = loginViewController //switch to loginViewController
        
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
