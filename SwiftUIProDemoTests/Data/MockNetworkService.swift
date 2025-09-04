import XCTest
import Combine
@testable import SwiftUIProDemo

final class MockNetworkService: NetworkServiceProtocol {
    var shouldReturnError = false
    var mockUsers: [User] = []
    var mockUser: User?
    
    func request<T: Codable>(endpoint: String, type: T.Type) -> AnyPublisher<T, NetworkError> {
        if shouldReturnError {
            return Fail(error: NetworkError.networkFailure("Mock error"))
                .eraseToAnyPublisher()
        }
        
        if type == [User].self {
            return Just(mockUsers as! T)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        } else if type == User.self, let user = mockUser {
            return Just(user as! T)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: NetworkError.noData)
            .eraseToAnyPublisher()
    }
}
