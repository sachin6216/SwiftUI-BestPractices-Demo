import Combine
import Foundation

protocol UserDetailViewModelProtocol: ObservableObject {
    var user: User { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
}

final class UserDetailViewModel: UserDetailViewModelProtocol {
    @Published var user: User
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userUseCase: UserUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(user: User, userUseCase: UserUseCaseProtocol) {
        self.user = user
        self.userUseCase = userUseCase
    }
    
    func refreshUserData() {
        isLoading = true
        errorMessage = nil
        
        userUseCase.fetchUser(id: user.id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] user in
                    self?.user = user
                }
            )
            .store(in: &cancellables)
    }
}
