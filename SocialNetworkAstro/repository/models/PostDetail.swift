import Foundation
public struct PostDetailF: Codable {

    let profilePhotoUrl: String
    let profileName: String
    let comment : String
    
    enum CodingKeys: String, CodingKey {
        case profilePhotoUrl
        case profileName
        case comment
    }
    var dictionary: [String: Any] {
            let data = (try? JSONEncoder().encode(self)) ?? Data()
            return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
        }
}
