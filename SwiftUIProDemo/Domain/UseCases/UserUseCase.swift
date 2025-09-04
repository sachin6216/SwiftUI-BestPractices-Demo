import Combine

protocol UserUseCaseProtocol {
    func fetchUsers() -> AnyPublisher<[User], NetworkError>
    func fetchUser(id: Int) -> AnyPublisher<User, NetworkError>
}

final class UserUseCase: UserUseCaseProtocol {
    private let networkService: NetworkServiceProtocol
    
    /// Dependency injection through initializer
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchUsers() -> AnyPublisher<[User], NetworkError> {
        networkService.request(endpoint: "/users", type: [User].self)
    }
    
    func fetchUser(id: Int) -> AnyPublisher<User, NetworkError> {
        networkService.request(endpoint: "/users/\(id)", type: User.self)
    }
}
