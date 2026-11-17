import SwiftUI

struct ContentView: View {
    @State private var count = 0

    var body: some View {
        VStack(spacing: 28) {
            Text("Hello, 这是我自己做的 App")
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            Text("\(count)")
                .font(.system(size: 80, weight: .bold, design: .rounded))
                .monospacedDigit()
                .contentTransition(.numericText())

            Button {
                withAnimation(.easeOut(duration: 0.2)) { count += 1 }
            } label: {
                Label("加一", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)

            Button("清零") { count = 0 }
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(32)
    }
}
