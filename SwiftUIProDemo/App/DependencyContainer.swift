import Foundation

protocol DependencyContainerProtocol {
    var networkService: NetworkServiceProtocol { get }
    var userUseCase: UserUseCaseProtocol { get }
}

final class DependencyContainer: DependencyContainerProtocol {
    
    lazy var networkService: NetworkServiceProtocol = NetworkService()
    lazy var userUseCase: UserUseCaseProtocol = UserUseCase(networkService: networkService)
}
