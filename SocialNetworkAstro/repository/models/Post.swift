import Foundation


public struct PostF: Codable {

    let title: String
    let description: String?
    let userID: String?
    let photoURL: String?
    let CountLikes: Int?
    let CreatedAt: TimeInterval

    enum CodingKeys: String, CodingKey {
        case title
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
