import Foundation

public struct UserF: Codable, BaseModel {
    var id: String
    let name: String
    let email: String
    let createdAt: String
    let photoUrl: String
    let photoPath: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case createdAt
        case photoUrl
        case photoPath
    }

    var dictionary: [String: Any] {
            let data = (try? JSONEncoder().encode(self)) ?? Data()
            return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
        }
    
    static func == (lhs: UserF, rhs: UserF) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.email == rhs.email
    }
}


 /*struct UserB: Codable, Equatable, BaseModel {
    var id: String
    let name: String
    let email: String
    let createdAt: String
    let photoUrl: String
    let photoPath: String
    
    static func == (lhs: UserB, rhs: UserB) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.email == rhs.email
    }
}*/

