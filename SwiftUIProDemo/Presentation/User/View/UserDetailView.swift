import SwiftUI

struct UserDetailView<ViewModel: UserDetailViewModelProtocol>: View {
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                userBasicInfo
                addressSection
                companySection
            }
            .padding()
        }
        .navigationTitle(viewModel.user.name)
        .navigationBarTitleDisplayMode(.large)
    }
    
    @ViewBuilder
    private var userBasicInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Contact Information")
                .font(.title2)
                .fontWeight(.bold)
            
            InfoRowView(title: "Email", value: viewModel.user.email)
            InfoRowView(title: "Phone", value: viewModel.user.phone)
            InfoRowView(title: "Website", value: viewModel.user.website)
            InfoRowView(title: "Username", value: viewModel.user.username)
        }
    }
    
    @ViewBuilder
    private var addressSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Address")
                .font(.title2)
                .fontWeight(.bold)
            
            let address = viewModel.user.address
            InfoRowView(title: "Street", value: "\(address.street), \(address.suite)")
            InfoRowView(title: "City", value: address.city)
            InfoRowView(title: "Zipcode", value: address.zipcode)
        }
    }
    
    @ViewBuilder
    private var companySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Company")
                .font(.title2)
                .fontWeight(.bold)
            
            let company = viewModel.user.company
            InfoRowView(title: "Name", value: company.name)
            InfoRowView(title: "Catch Phrase", value: company.catchPhrase)
            InfoRowView(title: "Business", value: company.bs)
        }
    }
}

/// Reusable info row component
/// Follows DRY principle and component reusability
struct InfoRowView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title + ":")
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 2)
    }
}
