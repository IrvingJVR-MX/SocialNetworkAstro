import Foundation

public struct UserF: Codable {
    let id: String
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
}

