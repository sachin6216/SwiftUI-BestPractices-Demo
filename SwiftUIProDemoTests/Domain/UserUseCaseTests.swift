import XCTest
import Combine
@testable import SwiftUIProDemo

final class UserUseCaseTests: XCTestCase {
    private var sut: UserUseCase!
    private var mockNetworkService: MockNetworkService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = UserUseCase(networkService: mockNetworkService)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchUsersSuccess() {
        let expectedUsers = [createMockUser(id: 1), createMockUser(id: 2)]
        mockNetworkService.mockUsers = expectedUsers
        let expectation = XCTestExpectation(description: "Fetch users success")
        
        sut.fetchUsers()
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("Expected success but got failure")
                    }
                },
                receiveValue: { users in
                    XCTAssertEqual(users, expectedUsers)
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchUsersFailure() {
        mockNetworkService.shouldReturnError = true
        let expectation = XCTestExpectation(description: "Fetch users failure")
        
        sut.fetchUsers()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        // Then
                        XCTAssertEqual(error, NetworkError.networkFailure("Mock error"))
                        expectation.fulfill()
                    }
                },
                receiveValue: { _ in
                    XCTFail("Expected failure but got success")
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
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
