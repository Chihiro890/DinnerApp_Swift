import Foundation

struct Comment: Codable {
    let id: Int
    let body: String
    let user_id: Int
    let dinner_id: Int
    let created_at: String
    let updated_at: String
    let user_name: String
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case body
//        case userName = "user_name"
//        case createdAt = "created_at"
//    }
}
