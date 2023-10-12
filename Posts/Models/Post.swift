//
//  Post.swift
//  Posts
//
//  Created by Luis Sergio Duran Arenas on 11/10/23.
//

import Foundation

struct Post : Codable {
    var id: Int?
    var userId: Int
    var title: String
    var body: String
}
