import XCTest
import Combine
@testable import SwiftUIProDemo

final class MockUserUseCase: UserUseCaseProtocol {
    var mockUsers: [User] = []
    var mockUser: User?
    var shouldReturnError = false
    
    func fetchUsers() -> AnyPublisher<[User], NetworkError> {
        if shouldReturnError {
            return Fail(error: NetworkError.networkFailure("Mock error"))
                .eraseToAnyPublisher()
        }
        return Just(mockUsers)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchUser(id: Int) -> AnyPublisher<User, NetworkError> {
        if shouldReturnError {
            return Fail(error: NetworkError.networkFailure("Mock error"))
                .eraseToAnyPublisher()
        }
        return Just(mockUser!)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
}
