import SwiftUI

struct ContentView: View {
  @State private var pollenData: PollenResponse?
  @State private var pollenDataFetched: Date?
  @State private var errorMessage: String?
  @State private var loading = false
  @Environment(\.scenePhase) private var scenePhase
  
  private var iso8601: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
  }()
  private var dateFormatter = DateFormatter()

  var body: some View {
    ScrollViewReader { viewReader in
      VStack(alignment: .leading) {
        List {
          if loading {
            ProgressView("Loading...")
          }
          if let pollenData = pollenData {
            ForEach(pollenData.cities, id: \.city) { city in
              CityView(city: city)
            }
            VStack(alignment: .leading) {
              Text("Data updated:")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 4)
              if let updateTime = iso8601.date(from: pollenData.updateTime) {
                Text(updateTime.formatted())
              } else {
                Text("Unable to parse updateTime stamp :O")
                  .foregroundStyle(.red)
              }
            }
            VStack(alignment: .leading) {
              Text("Last fetch:")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 4)
              if let pollenDataFetched = pollenDataFetched {
                Text(pollenDataFetched.formatted())
              } else {
                Text("<No date for fetch>")
              }
            }
          } else if let errorMessage = errorMessage, !loading {
            Text("Error: \(errorMessage)")
              .foregroundStyle(.red)
          }
          Button(loading ? "Reloading..." : "Refetch data") {
            Task {
              await fetchData()
              withAnimation{
                viewReader.scrollTo("top")
              }
            }
          }.disabled(loading)
        }
      }
    }
      .task {
          await fetchData()
      }
      .padding(.horizontal, 1)
      .onAppear{
        Task {
          await fetchData()
        }
      }
      .onChange(of: scenePhase) { oldPhase, newPhase in
        if oldPhase != newPhase && newPhase == .active {
          Task {
            await fetchData()
          }
        }
      }
  }

  private func fetchData() async {
    // TODO: This is not really thread safe or anything, we should implement properly later 😊
    if loading {
      return
    }
    loading = true
    do {
      pollenData = try await PollenApi.shared.fetchData()
      pollenDataFetched = Date()
      errorMessage = nil;
    } catch {
      pollenData = nil;
      pollenDataFetched = nil;
      errorMessage = error.localizedDescription
    }
    loading = false
  }
}

#Preview {
    ContentView()
}
