import Combine
import Foundation

protocol UserListViewModelProtocol: ObservableObject {
    var users: [User] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    
    func loadUsers()
    func refreshUsers()
}

final class UserListViewModel: UserListViewModelProtocol {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userUseCase: UserUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    private weak var coordinator: AppCoordinatorProtocol?
    
    init(userUseCase: UserUseCaseProtocol, coordinator: AppCoordinatorProtocol) {
        self.userUseCase = userUseCase
        self.coordinator = coordinator
    }
    
    func loadUsers() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        userUseCase.fetchUsers()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] users in
                    self?.users = users
                }
            )
            .store(in: &cancellables)
    }
    
    func refreshUsers() {
        users.removeAll()
        loadUsers()
    }
    
    func selectUser(_ user: User) {
        coordinator?.showUserDetail(user)
    }
}
