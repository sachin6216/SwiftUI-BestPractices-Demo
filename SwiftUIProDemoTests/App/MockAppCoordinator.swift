import XCTest
@testable import SwiftUIProDemo

final class MockAppCoordinator: AppCoordinatorProtocol {
    var showUserDetailCalled = false
    var dismissUserDetailCalled = false
    var presentedUser: User?
    
    func showUserDetail(_ user: User) {
        showUserDetailCalled = true
        presentedUser = user
    }
    
    func dismissUserDetail() {
        dismissUserDetailCalled = true
        presentedUser = nil
    }
}
