import Foundation
public struct PostDetailF: Codable, BaseModel{

    var id : String
    let profilePhotoUrl: String
    let profileName: String
    let comment : String
    
    enum CodingKeys: String, CodingKey {
        case id 
        case profilePhotoUrl
        case profileName
        case comment
    }
    var dictionary: [String: Any] {
            let data = (try? JSONEncoder().encode(self)) ?? Data()
            return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
        }
    
    static func == (lhs: PostDetailF, rhs: PostDetailF) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.profilePhotoUrl == rhs.profilePhotoUrl &&
            lhs.profileName == rhs.profileName
    }
}
