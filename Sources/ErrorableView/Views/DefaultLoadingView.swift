//
//  DefaultLoadingView.swift
//
//
//  Created by Mehmet Ateş on 24.11.2023.
//

import SwiftUI

public protocol LoadingView: View {
    var type: LoadingPresenterTypes { get set }
}

@frozen public struct DefaultLoadingView: LoadingView {
    var loadingText: LocalizedStringKey
    var progressViewColor: Color
    public var type: LoadingPresenterTypes

    public init(loadingText: LocalizedStringKey,
                progressViewColor: Color = .accentColor,
                type: LoadingPresenterTypes = .overlay
    ) {
        self.loadingText = loadingText
        self.progressViewColor = progressViewColor
        self.type = type
    }

    public var body: some View {
        #if os(macOS)
        ZStack {
            Rectangle()
                .opacity(type == .onPage ? 1 : 0.3)
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
        }.ignoresSafeArea()
        #else
        ZStack {
            Rectangle()
                .opacity(type == .onPage ? 1 : 0.3)
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
        }.ignoresSafeArea()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        #endif
    }
}

#Preview {
    DefaultLoadingView(loadingText: "Loading...")
}
