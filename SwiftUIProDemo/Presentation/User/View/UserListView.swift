import SwiftUI

struct UserListView<ViewModel: UserListViewModelProtocol>: View {
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading && viewModel.users.isEmpty {
                    ProgressView("Loading users...")
                } else {
                    userListContent
                }
            }
            .navigationTitle("Users")
            .refreshable {
                viewModel.refreshUsers()
            }
            .onAppear {
                if viewModel.users.isEmpty {
                    viewModel.loadUsers()
                }
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    // Error handling could be expanded here
                }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error occurred")
            }
        }
    }
    
    @ViewBuilder
    private var userListContent: some View {
        List(viewModel.users) { user in
            UserRowView(user: user) {
                if let userListVM = viewModel as? UserListViewModel {
                    userListVM.selectUser(user)
                }
            }
        }
    }
}
