import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userid: String?
    @NSManaged public var photoUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var photoPath: String?

}

extension User : Identifiable {

}
