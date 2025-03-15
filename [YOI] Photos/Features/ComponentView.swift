//
//  ComponentView.swift
//  WarmCoolerDetect
//
//  Created by Irvan P. Saragi on 01/03/25.
//

import SwiftUI

struct ImagePlaceholderView: View {
    var body: some View {
        VStack {
            Image(systemName: "photo")
                .font(.system(size: 80))
                .padding()
                .foregroundColor(.gray)
            Text(DataConstans.noImageSelectedTitle)
                .font(.title2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding()
    }
}

struct ButtonLabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 150)
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
    }
}

extension View {
    func buttonStyle() -> some View {
        self.modifier(ButtonLabelStyle())
    }
}

enum ImageError: Error {
    case loadFailed
}
