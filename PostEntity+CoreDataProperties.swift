//
//  PostEntity+CoreDataProperties.swift
//  Posts
//
//  Created by Luis Sergio Duran Arenas on 14/10/23.
//
//

import Foundation
import CoreData


extension PostEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostEntity> {
        return NSFetchRequest<PostEntity>(entityName: "PostEntity")
    }

    @NSManaged public var userId: Int16
    @NSManaged public var title: String?
    @NSManaged public var body: String?

}

extension PostEntity : Identifiable {

}
