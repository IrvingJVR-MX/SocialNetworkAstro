import Foundation

public struct UserF: Codable, BaseModel {
    var id: String
    let name: String
    let email: String
    let createdAt: String
    let photoUrl: String
    let photoPath: String
    
    static func == (lhs: UserF, rhs: UserF) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.email == rhs.email
    }
}

