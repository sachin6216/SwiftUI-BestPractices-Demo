import Combine
import Foundation

protocol NetworkServiceProtocol {
    func request<T: Codable>(endpoint: String, type: T.Type) -> AnyPublisher<T, NetworkError>
}

final class NetworkService: NetworkServiceProtocol {
    private let baseURL = "https://jsonplaceholder.typicode.com"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Codable>(endpoint: String, type: T.Type) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: baseURL + endpoint) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.networkFailure("Invalid response")
                }
                
                guard 200...299 ~= httpResponse.statusCode else {
                    throw NetworkError.serverError(httpResponse.statusCode)
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if error is DecodingError {
                    return .decodingError
                } else if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return .networkFailure(error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
}
