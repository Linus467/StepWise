import SwiftUI

struct ExplanationViewTest: View {
    @State private var isAnimating = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    Spacer()

                    Text("Welcome to Our DIY Page!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.yellow.opacity(0.3))
                        .cornerRadius(10)

                    Image("StepWise")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .onAppear {
                            withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: false)) {
                                isAnimating = true
                            }
                        }

                    Text("Discover exciting projects, creative ideas, and more.")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(10)

                    VStack(spacing: 20) {
                        NavigationLink(destination: BrowserView2()) {
                            ModernCardView(text: "Browse Projects", color: .blue, iconName: "magnifyingglass")
                        }

                        NavigationLink(destination: FavoritesView2()) {
                            ModernCardView(text: "Favorite Projects", color: .orange, iconName: "heart.fill")
                        }

                        NavigationLink(destination: SearchView2()) {
                            ModernCardView(text: "Search Projects", color: .purple, iconName: "magnifyingglass")
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding()
                .navigationBarTitle("Welcome", displayMode: .inline)
            }
        }
    }
}

struct ModernCardView: View {
    var text: String
    var color: Color
    var iconName: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()

            Text(text)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Spacer()
        }
        .padding()
        .background(color)
        .cornerRadius(15)
        .shadow(color: color.opacity(0.4), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

struct BrowserView2: View {
    var body: some View {
        Text("Browse all DIY projects. Select a project to view details.")
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .padding()
            .navigationBarTitle("Browse", displayMode: .inline)
    }
}

struct FavoritesView2: View {
    var body: some View {
        Text("Here are your favorite projects. Maybe your next DIY?")
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .padding()
            .navigationBarTitle("Favorites", displayMode: .inline)
    }
}

struct SearchView2: View {
    var body: some View {
        Text("Search for projects")
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .padding()
            .navigationBarTitle("Search", displayMode: .inline)
    }
}

struct ExplanationViewTest_Previews: PreviewProvider {
    static var previews: some View {
        ExplanationView()
    }
}
