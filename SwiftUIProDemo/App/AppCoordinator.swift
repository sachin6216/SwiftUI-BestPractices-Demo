import SwiftUI

enum NavigationAction {
    case showUserDetail(User)
    case dismissUserDetail
}

protocol AppCoordinatorProtocol: AnyObject {
    func showUserDetail(_ user: User)
    func dismissUserDetail()
}

final class AppCoordinator: AppCoordinatorProtocol, ObservableObject {
    @Published var navigationPath = NavigationPath()
    @Published var presentedUser: User?
    
    private let dependencyContainer: DependencyContainerProtocol
    
    init(dependencyContainer: DependencyContainerProtocol) {
        self.dependencyContainer = dependencyContainer
    }
    
    func showUserDetail(_ user: User) {
        presentedUser = user
    }
    
    func dismissUserDetail() {
        presentedUser = nil
    }
    
    func makeUserListViewModel() -> UserListViewModel {
        UserListViewModel(
            userUseCase: dependencyContainer.userUseCase,
            coordinator: self
        )
    }
    
    func makeUserDetailViewModel(for user: User) -> UserDetailViewModel {
        UserDetailViewModel(
            user: user,
            userUseCase: dependencyContainer.userUseCase
        )
    }
}
