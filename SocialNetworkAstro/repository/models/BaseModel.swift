import Foundation

protocol BaseModel {
    var id: String { get set }
}

struct DefaultsKeys {
    static let userId = "userId"
}
