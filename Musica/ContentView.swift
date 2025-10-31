//
//  ContentView.swift
//  Musica
//
//  Created by Miksa on 15.10.25.
//

import SwiftUI

struct ContentView: View {
    let date = Date()

    var body: some View {
        TimelineView(.animation) { _ in
            GeometryReader { geo in
                Color.black.ignoresSafeArea()
                    .colorEffect(
                        ShaderLibrary.lines(
                            .float2(geo.size),
                            .float(date.timeIntervalSinceNow)
                        )
                    )
            }

        }
    }
}

#Preview {
    ContentView()
}
