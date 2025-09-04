import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case noData
    case decodingError
    case networkFailure(String)
    case serverError(Int)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .noData:
            return "No data received from server"
        case .decodingError:
            return "Failed to decode response data"
        case .networkFailure(let message):
            return "Network failure: \(message)"
        case .serverError(let code):
            return "Server error with code: \(code)"
        }
    }
}
