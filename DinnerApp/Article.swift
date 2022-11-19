
import Foundation

//struct Articles: Codable {
//    let data: [Article]
//}
struct Article: Codable {
    let id: Int
    let title: String
    let country: String
    let other: String?
    let user_id: Int
    let category_id: Int?
    let description: String
    let created_at: String
    let updated_at: String
    let user_name: String
//    let category_name: String
    let calendar: String
    let comments: [Comment]?
    
        enum CodingKeys:  String, CodingKey {
            case id
            case title
            case country
            case other
            
            case user_id
            case category_id
            case description
            case created_at
            case updated_at
            case user_name
//            case category_name
            case calendar
            case comments
        }
    
    func calendarDate() -> Date {
           let dateFormatter = DateFormatter()
           dateFormatter.calendar = Calendar(identifier: .gregorian)
           dateFormatter.dateFormat = "yyyy/MM/dd"
           return dateFormatter.date(from: calendar) ?? Date()
       }
}
