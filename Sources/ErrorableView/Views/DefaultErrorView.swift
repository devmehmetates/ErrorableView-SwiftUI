//
//  DefaultErrorView.swift
//
//
//  Created by Mehmet Ateş on 24.11.2023.
//

import SwiftUI

@frozen public struct DefaultErrorView: View {
    var model: ErrorStateConfigureModel
    var type: ErrorPresentTypes

    public var body: some View {
        VStack {
            if type != .onPage {
                HStack {
                    Spacer()
                    Button {
                        model.buttonAction?()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                    }.accentColor(.secondary)
                }.padding(.horizontal)
            }
            Spacer()

            VStack {
                Group {
                    if let icon = model.icon {
                        Image(icon)
                    } else if let systemName = model.systemName {
                        Image(systemName: systemName)
                    }
                }.imageScale(.large)
                    .font(.largeTitle)
                
                Text(model.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }.padding(.bottom)
            
            if let subtitle = model.subtitle {
                Group {
                    if #available(iOS 15.0, *) {
                        Text(subtitle)
                            .foregroundStyle(.secondary)
                    } else {
                        Text(subtitle)
                            .foregroundColor(.secondary)
                    }
                }.font(.headline)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            if let buttonTitle = model.buttonTitle {
                if #available(iOS 15.0, *) {
                    Button {
                        model.buttonAction?()
                    } label: {
                        Spacer()
                        Text(buttonTitle)
                            .bold()
                            .padding(.vertical, 5)
                        Spacer()
                    }.buttonStyle(.borderedProminent)
                        .padding(.horizontal)
                } else {
                    Button {
                        model.buttonAction?()
                    } label: {
                        Spacer()
                        Text(buttonTitle)
                            .bold()
                        Spacer()
                    }.modifier(ErrorStateButtonModifier())
                        .padding(.horizontal)
                }
            }
        }.padding(.vertical)
    }
}

#Preview {
    DefaultErrorView(model: .Builder().build(), type: .onPage)
}
