import Foundation


public struct userFollowedDetail : Codable, BaseModel {
    var id : String
    let name: String
    let profilePhotoUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePhotoUrl
    }

    var dictionary: [String: Any] {
            let data = (try? JSONEncoder().encode(self)) ?? Data()
            return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
        }
    static func == (lhs: userFollowedDetail, rhs: userFollowedDetail) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.profilePhotoUrl == rhs.profilePhotoUrl
    }
}
