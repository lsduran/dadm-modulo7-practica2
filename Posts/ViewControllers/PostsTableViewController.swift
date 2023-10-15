//
//  PostsTableViewController.swift
//  Posts
//
//  Created by Luis Sergio Duran Arenas on 12/10/23.
//

import UIKit
import CoreData

class PostsTableViewController: UITableViewController {
    
    @IBOutlet var lblEmptyPosts: UILabel!
    
    @IBOutlet var btnAddPost: UIBarButtonItem!
    
    @IBOutlet var btnRefreshPosts: UIBarButtonItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var deleteRequest: NSBatchDeleteRequest?
    
    var postDataManager: PostDataManager?
    
    var postService: PostService?
    
    var post: PostEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postService = PostService()
        postDataManager = PostDataManager(context: context)
        postDataManager?.fetch()
        updateEmptyView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDataManager?.countPosts() ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        
        let post = postDataManager?.getPost(at: indexPath.row)
        
        cell.lblTitle.text = "\(indexPath.row) - \(post!.title ?? "NO DATA")"
        
        cell.lblBody.text = post?.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            postDataManager?.deletePost(at: indexPath.row)
            postService?.deletePost(id: 100) { statusCode in
                print("Post deleted. Statud code: ", statusCode)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            updateEmptyView()
            
        } else if editingStyle == .insert {
            
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //perform segue when user touches a cell
        performSegue(withIdentifier: "showPostSegue", sender: self)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPostSegue" {
            let destination = segue.destination as! AddPostViewController
            destination.post = postDataManager?.getPost(at: self.tableView.indexPathForSelectedRow!.row)
        }
    }
    
    @IBAction func unwindFromAddNoteViewController(segue: UIStoryboardSegue) {
        print("Unwind segue!")
        
        let source = segue.source as! AddPostViewController
        
        post = source.post
        
        let postModel: PostModel = PostModel(userId: Int(post!.userId), title: (post?.title)!, body: (post?.body)!)
        
        if source.newPostFlag {
            postService?.createPost(post: postModel){ postCreated in
                print("Post created: ", postCreated as Any)
            }
        } else {
            postService?.updatePost(post: postModel) { postUpdated in
                print("Post updated: ", postUpdated as Any)
            }
        }
        
        postDataManager?.save()
        
        postDataManager?.fetch()
        
        reloadUI()
        
    }
    
    @IBAction func loadRemotePosts(_ sender: UIBarButtonItem) {
        
        postService?.getPosts {
            for post in self.postService!.posts {
                let postEntity = PostEntity(context: self.context)
                postEntity.body = post.body
                postEntity.title = post.title
                postEntity.userId = Int16(post.userId)
            }
            self.postDataManager?.save()
            
            self.postDataManager?.fetch()
            
            self.reloadUI()
        }
    }
    
    @IBAction func deleteAllData(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure that you want to delete all the posts?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Accept", style: UIAlertAction.Style.destructive) { _ in
            do {
                self.deleteRequest = NSBatchDeleteRequest(fetchRequest: PostEntity.fetchRequest())
                try self.context.persistentStoreCoordinator!.execute(self.deleteRequest!, with: self.context)
                self.postDataManager?.fetch()
                self.reloadUI()
            } catch let error {
                print("ERROR: deleteAllData - ", error)
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func reloadUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateEmptyView()
        }
    }
    
    func updateEmptyView() {
        if postDataManager?.countPosts() == 0 {
            
            lblEmptyPosts.isHidden = false
            
            self.tableView.backgroundView = lblEmptyPosts
            
        } else {
            
            lblEmptyPosts.isHidden = true
            
        }
    }

}
