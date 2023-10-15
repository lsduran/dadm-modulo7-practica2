//
//  PostManager.swift
//  Posts
//
//  Created by Luis Sergio Duran Arenas on 14/10/23.
//

import Foundation
import CoreData

class PostDataManager {
    
    private var posts: [PostEntity] = []
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: CRUD methods
    
    // MARK: CREATE
    func createPost(userId: Int, title: String, body: String) -> PostEntity? {
        
        let newPost = PostEntity(context: context)
        newPost.userId = Int16(userId)
        newPost.title = title
        newPost.body = body
        do {
            try context.save()
            return newPost
        } catch let error {
            print("ERROR: createPost - ", error)
            return nil
        }
    }
    
    func createPost(post: PostEntity) -> PostEntity? {
        return self.createPost(userId: Int(post.userId), title: post.title!, body: post.body!)
    }
    
    // MARK: READ
    func fetch() {
        do {
            self.posts = try self.context.fetch(PostEntity.fetchRequest())
        } catch let error {
            print("ERROR: getPosts - ", error)
        }
    }
    
    func getPost(at index: Int) -> PostEntity {
        return self.posts[index]
    }
    
    func countPosts() -> Int {
        return self.posts.count
    }
    
    // MARK: UPDATE
    func updatePost(at index: Int, post: PostEntity) {
        self.posts[index] = post
        self.save()
    }
    
    // MARK: DELETE
    func deletePost(at index: Int) {
        context.delete(posts[index])
        self.posts.remove(at: index)
        self.save()
    }
    
    // MARK: SAVE
    func save() {
        do {
            try context.save()
        } catch let error {
            print("ERROR: save - ", error)
        }
    }
//
    
}
