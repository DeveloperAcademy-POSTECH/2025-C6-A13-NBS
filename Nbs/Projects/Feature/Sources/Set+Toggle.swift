import Foundation

extension Set where Element: Equatable {
  mutating func toggle(_ element: Element) {
    if contains(element) {
      remove(element)
    } else {
      insert(element)
    }
  }
}
