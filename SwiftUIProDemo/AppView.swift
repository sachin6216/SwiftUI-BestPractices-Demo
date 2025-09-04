import SwiftUI

struct AppView: View {
    @StateObject private var coordinator: AppCoordinator
    
    init(dependencyContainer: DependencyContainerProtocol = DependencyContainer()) {
        self._coordinator = StateObject(wrappedValue: AppCoordinator(dependencyContainer: dependencyContainer))
    }
    
    var body: some View {
        UserListView(viewModel: coordinator.makeUserListViewModel())
            .sheet(item: .constant(coordinator.presentedUser)) { user in
                NavigationView {
                    UserDetailView(viewModel: coordinator.makeUserDetailViewModel(for: user))
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done") {
                                    coordinator.dismissUserDetail()
                                }
                            }
                        }
                }
            }
    }
}
