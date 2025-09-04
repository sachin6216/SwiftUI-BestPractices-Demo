import SwiftUI

struct UserRowView: View {
    let user: User
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(user.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(user.email)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(user.company.name)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}
