//
//  DefaultLoadingView.swift
//
//
//  Created by Mehmet Ateş on 24.11.2023.
//

import SwiftUI

@frozen public struct DefaultLoadingView: View {
    public var body: some View {
        VStack {
            if #available(iOS 15.0, *) {
                ProgressView()
                    .scaleEffect(1.2)
                    .tint(.accentColor)
            }  else {
                ProgressView()
                    .scaleEffect(1.2)
            }
            Text("Loading...")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top)
        }
    }
}

#Preview {
    DefaultLoadingView()
}
