import SwiftUI

struct MiniView: View {
    let color: Color

    var body: some View {
        Rectangle()
            .foregroundColor(color)
            .cornerRadius(2)
    }
}
