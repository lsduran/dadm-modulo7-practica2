//
//  PostService.swift
//  Posts
//
//  Created by Luis Sergio Duran Arenas on 11/10/23.
//

import Foundation

class PostService {
    
    static let shared = PostService()
    
    init () {}
    
    // Create
    func createPost(post : Post, completion: @escaping (Post?) -> Void) {
        guard let url = URL(string: Constants.POSTS_ENDPOINT) else {
            completion(nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") //value - key
        
        do {
            //Encode our post
            let jsonData = try JSONEncoder().encode(post)
            
            print("JSON:", try JSONSerialization.jsonObject(with: jsonData) )
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    //Handle response data
                    if let createdPost = try? JSONDecoder().decode(Post.self, from: data) {
                        completion(createdPost)
                    }
                } else if let error = error {
                    print("Error:", error)
                    completion(nil)
                }
            }
            task.resume()
        } catch let error{
            print("Error:", error)
            completion(nil)
        }
    }
    
    //Update method
    func updatePost(post : Post, completion: @escaping (Post?) -> Void) {
        let urlString = Constants.POSTS_ENDPOINT + String(post.id!)
        print("urlString:", urlString)
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") //value - key
    
        do {
            //Encode our post
            let jsonData = try JSONEncoder().encode(post)
            print("JSON:", try JSONSerialization.jsonObject(with: jsonData) )
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    //Handle response data
                    if let updatedPost = try? JSONDecoder().decode(Post.self, from: data) {
                        completion(updatedPost)
                    }
                } else if let error = error {
                    print("Error:", error)
                    completion(nil)
                }
            }
            task.resume()
        } catch let error{
            print("Error:", error)
            completion(nil)
        }
    }
    
    //Delete
    func deletePost(id: Int, completion: @escaping (Int) -> Void) {
        let urlString = Constants.POSTS_ENDPOINT + String(id)
        print("urlString:", urlString)
        
        guard let url = URL(string: urlString) else {
            completion(0)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                completion(response.statusCode)
            } else if let error = error {
                print("Error:", error)
                completion(0)
            }
        }
        task.resume()
    }
}
