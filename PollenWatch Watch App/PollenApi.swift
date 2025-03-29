import Foundation

enum PollenLevelSeverity: String, Codable {
  case none
  case low
  case medium
  case high
}
struct PollenLevel: Codable {
  let label: String
  let level: Int?
  let severity: PollenLevelSeverity
  let inSeason: Bool
}
struct PollenCity: Codable {
  let city: String
  let levels: [PollenLevel]
}
struct PollenResponse: Codable {
  let updateTime: String
  let cities: [PollenCity]
}
class PollenApi {
  static let shared = PollenApi()
  
  private init() {}
  
  func fetchData() async throws -> PollenResponse {
    guard let url = URL(string: "https://pollen.dhedegaard.dk/json") else {
      throw URLError(.badURL)
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw URLError(.badServerResponse)
    }
    return try JSONDecoder().decode(PollenResponse.self, from: data)
  }
}
