//
//  DefaultLoadingView.swift
//
//
//  Created by Mehmet Ateş on 24.11.2023.
//

import SwiftUI

@frozen public struct DefaultLoadingView: View {
    var loadingText: LocalizedStringKey
    var progressViewColor: Color

    public init(loadingText: LocalizedStringKey,
                progressViewColor: Color = .accentColor
    ) {
        self.loadingText = loadingText
        self.progressViewColor = progressViewColor
    }

    public var body: some View {
        VStack {
            if #available(iOS 15.0, *) {
                ProgressView()
                    .scaleEffect(1.2)
                    .tint(progressViewColor)
            }  else {
                ProgressView()
                    .scaleEffect(1.2)
            }
            Text(loadingText)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top)
        }
    }
}

#Preview {
    DefaultLoadingView(loadingText: "Loading...")
}
