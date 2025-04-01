import SwiftUI

func severityToColor(severity: PollenLevelSeverity) -> Color {
  switch severity {
  case .high:
    Color.red
  case .medium:
    Color.orange
  case .low:
    Color.green
  case .none:
    Color.gray
  }
}

struct PollenLevelView : View {
  let pollen: PollenLevel

  var body: some View {
    HStack() {
      Text("\(pollen.label):")
        .foregroundStyle(pollen.severity == .none ? .gray : .primary)
      Spacer()
      let level = pollen.level ?? 0
      Text(level == 0 ? "-" : String(level))
        .foregroundStyle(severityToColor(severity: pollen.severity))
    }
  }
}
