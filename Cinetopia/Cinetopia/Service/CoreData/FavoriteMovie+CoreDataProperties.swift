//
//  FavoriteMovie+CoreDataProperties.swift
//  Cinetopia
//
//  Created by Bruno Moura on 26/07/24.
//
//

import Foundation
import CoreData


extension FavoriteMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovie> {
        return NSFetchRequest<FavoriteMovie>(entityName: String(describing: FavoriteMovie.self))
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var imageURL: String

}

extension FavoriteMovie : Identifiable {

}
