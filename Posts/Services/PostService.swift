//
//  PostService.swift
//  Posts
//
//  Created by Luis Sergio Duran Arenas on 11/10/23.
//

import Foundation

class PostService {
    
    static let shared = PostService()
    
    var posts : [PostModel] = []
    
    init () {}
    
    // Create
    func createPost(post : PostModel, completion: @escaping (PostModel?) -> Void) {
        guard let url = URL(string: Constants.POSTS_URL) else {
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
                    if let createdPost = try? JSONDecoder().decode(PostModel.self, from: data) {
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
    
    //Read
    
    func getPosts(completion: @escaping () -> Void) {
        let url = URL(string: Constants.POSTS_URL)!
        let session = URLSession.shared
        var httpResponse = HTTPURLResponse()
        var loadedPosts : [PostModel] = []
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            // Check response
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Invalid response")
                httpResponse = (response as? HTTPURLResponse)!
                print("statusCode: ", httpResponse.statusCode)
                return
            }
            
            // Check if there is any data
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Parse and use the data
            do {
                let decodedResponse = try JSONDecoder().decode([PostModel].self, from: data)
                
                // print("response: ", decodedResponse )
                
                loadedPosts = decodedResponse
                
                for post in loadedPosts {
                    self.posts.append(post)
                }
                
            } catch let error{
                loadedPosts = []
                print("JSON parsing error: \(error)")
            }
            completion()
        }
        
        // Start the task
        task.resume()
    }
    
    //Update method
    func updatePost(post : PostModel, completion: @escaping (PostModel?) -> Void) {
        let urlString = Constants.POSTS_URL + String(1)
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
                    if let updatedPost = try? JSONDecoder().decode(PostModel.self, from: data) {
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
        let urlString = Constants.POSTS_URL + String(id)
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
