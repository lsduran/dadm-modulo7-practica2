//
//  AddPostViewController.swift
//  Posts
//
//  Created by Luis Sergio Duran Arenas on 12/10/23.
//

import UIKit

class AddPostViewController: UIViewController {

    @IBOutlet weak var postTitle: UITextView!
    
    @IBOutlet weak var postBody: UITextView!
    
    var post: PostEntity?
    
    var newPostFlag: Bool = true 
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTitle.delegate = self
        postBody.delegate = self

        if post != nil {
            postTitle.text = post?.title
            postBody.text = post?.body
            newPostFlag = false
        } else {
            post = PostEntity(context: context)
            post?.title = ""
            post?.body = ""
            post?.userId = 1
            newPostFlag = true
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
        // Esta línea de código es necesaria para que la entidad vacía que se crea al abrir AddPostViewController se descarte y no se almacene al guardar el contexto
        post?.managedObjectContext?.refresh(post!, mergeChanges: false)
        
        let isModal = self.presentingViewController is UINavigationController
        print("isModal: ",isModal)
        if isModal {
            self.dismiss(animated: true)
        }
        else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        post?.userId = 1
        post?.title = postTitle.text
        post?.body = postBody.text
        
        let destination = segue.destination as! PostsTableViewController
        
        destination.post = post
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if !validatePost() {
            print("Invalid post")
            return false
        }
        return true
    }
    
    private func validatePost() -> Bool {
        if postTitle.text.isEmpty {
            postTitle.borderColor = .red
        }
        
        if postBody.text.isEmpty {
            postBody.borderColor = .red
        }
        
        return !postTitle.text.isEmpty && !postBody.text.isEmpty
    }

}
