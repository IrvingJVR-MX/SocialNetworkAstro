import Foundation


public struct PostF: Codable {
    let postId: String
    let title: String
    let profileName : String
    let profilePhotoUrl: String
    let description: String?
    let userID: String?
    let photoURL: String?
    let CountLikes: Int?
    let CreatedAt: TimeInterval

    enum CodingKeys: String, CodingKey {
        case postId
        case title
        case profileName
        case profilePhotoUrl
        case description
        case userID
        case photoURL
        case CountLikes
        case CreatedAt
    }
    var dictionary: [String: Any] {
            let data = (try? JSONEncoder().encode(self)) ?? Data()
            return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
        }
}
