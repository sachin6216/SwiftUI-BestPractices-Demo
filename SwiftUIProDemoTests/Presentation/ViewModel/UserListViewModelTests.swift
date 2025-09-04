import XCTest
import Combine
@testable import SwiftUIProDemo

final class UserListViewModelTests: XCTestCase {
    private var sut: UserListViewModel!
    private var mockUserUseCase: MockUserUseCase!
    private var mockCoordinator: MockAppCoordinator!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockUserUseCase = MockUserUseCase()
        mockCoordinator = MockAppCoordinator()
        sut = UserListViewModel(userUseCase: mockUserUseCase, coordinator: mockCoordinator)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        mockUserUseCase = nil
        mockCoordinator = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testLoadUsersSuccess() {
        let expectedUsers = [createMockUser(id: 1)]
        mockUserUseCase.mockUsers = expectedUsers
        
        sut.loadUsers()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut.users, expectedUsers)
            XCTAssertFalse(self.sut.isLoading)
            XCTAssertNil(self.sut.errorMessage)
        }
    }
    
    func testLoadUsersFailure() {
        mockUserUseCase.shouldReturnError = true
        
        sut.loadUsers()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.sut.users.isEmpty)
            XCTAssertFalse(self.sut.isLoading)
            XCTAssertNotNil(self.sut.errorMessage)
        }
    }
    
    private func createMockUser(id: Int) -> User {
        User(
            id: id,
            name: "Test User \(id)",
            email: "test\(id)@example.com",
            username: "testuser\(id)",
            phone: "123-456-789\(id)",
            website: "test\(id).com",
            address: User.Address(
                street: "Test Street \(id)",
                suite: "Suite \(id)",
                city: "Test City",
                zipcode: "1234\(id)"
            ),
            company: User.Company(
                name: "Test Company \(id)",
                catchPhrase: "Test Phrase",
                bs: "Test BS"
            )
        )
    }
}
