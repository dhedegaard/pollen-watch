import SwiftUI

struct CityView : View {
  let city: PollenCity
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(city.city)
        .font(.title3)
        .padding(.bottom, 4)
      ForEach(city.levels.filter { $0.inSeason }, id: \.label) { pollen in
        PollenLevelView(pollen: pollen)
      }
    }
  }
}
