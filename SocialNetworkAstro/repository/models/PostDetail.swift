import Foundation
public struct PostDetailF: Codable {

    let one: String
    let two: String
    
    enum CodingKeys: String, CodingKey {
        case one
        case two
    }
    var dictionary: [String: Any] {
            let data = (try? JSONEncoder().encode(self)) ?? Data()
            return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
        }
}
