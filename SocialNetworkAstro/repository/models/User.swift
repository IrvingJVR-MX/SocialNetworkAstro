import Foundation

struct UserF: Codable, BaseModel {
    var id: String
    let name: String
    let email: String
    let createdAt: String
}
