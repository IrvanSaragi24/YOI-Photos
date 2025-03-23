//
//  Router.swift
//  [YOI] Photos
//
//  Created by bernardus kanayari on 15/03/25.
//

import Foundation
import SwiftUI

enum Destination: Hashable {
    case photoEditor
    case contrast
    case enhancer
    case saturation
    case warmth
    case splashScreen
}

@MainActor
class Router: ObservableObject {
    @Published var path: [Destination] = []

    func popToRoot() {
      DispatchQueue.main.async {
        self.path.removeLast(self.path.count)
      }
    }

    func popToPage(page: Destination) {
      if let index = path.firstIndex(where: { $0 == page }) {
        path.removeLast(path.count - (index + 1))
      } else {
        print("Value not found in the array")
      }
    }
}

class ViewFactory {
  @ViewBuilder
  static func viewForDestination(_ destination: Destination) -> some View {
    switch destination {
    case .photoEditor:
        PhotoEdit()
    case .contrast:
        ContrastEditorView()
    case .saturation:
        SaturationEditorView()
    case .enhancer:
        EnhancerEditorView()
    case .warmth:
        ImageWarmCoolerView()
    case .splashScreen:
        SplashScreen()
    }
  }
}
