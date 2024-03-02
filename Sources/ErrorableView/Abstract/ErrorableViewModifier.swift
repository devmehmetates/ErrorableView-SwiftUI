//
//  File.swift
//  
//
//  Created by Mehmet Ateş on 1.03.2024.
//

import SwiftUI

public struct ErrorableViewModifier<ErrorContent: ErrorableView>: ViewModifier {
    @State private var sheetTrigger: Bool = false
    @Binding var pageState: PageStates
    var errorContent: ErrorContent

    init(pageState: Binding<PageStates>,
         @ViewBuilder errorContent: () -> ErrorContent) {
        self._pageState = pageState
        self.errorContent = errorContent()
    }

    public func body(content: Content) -> some View {
        switch errorContent.type {
        case .onPage:
            onPageState(content: content)
        case .sheet:
            sheetState(content: content)
        case .fullScreen:
            sheetState(content: content)
        }
    }

    @ViewBuilder
    private func onPageState(content: Content) -> some View {
        switch pageState {
        case .failure:
            errorContent
        case .loading:
            DefaultLoadingView(loadingText: "Loading...")
        case .successful:
            content
        }
    }

    @ViewBuilder
    private func sheetState(content: Content) -> some View {
        Group {
            if pageState == .successful {
                content
            } else {
                DefaultLoadingView(loadingText: "Loading...")
            }
        }.onChange(of: pageState) { newValue in
            sheetTrigger = (newValue == .failure)
        }.sheet(isPresented: $sheetTrigger) {
            errorContent
        }
    }

    @ViewBuilder
    private func fullscreenState(content: Content) -> some View {
        Group {
            if pageState == .successful {
                content
            } else {
                DefaultLoadingView(loadingText: "Loading...")
            }
        }.onChange(of: pageState) { newValue in
            sheetTrigger = (newValue == .failure)
        }.fullScreenCover(isPresented: $sheetTrigger) {
            errorContent
        }
    }
}

@available(iOS 15.0, *)
struct TestView: View {
    @State private var pageState: PageStates = .loading

    var body: some View {
            NavigationView {
                ScrollView {
                    ForEach(0..<100, id: \.self) { _ in
                        AsyncImage(url: URL(string: "https://picsum.photos/1000")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Color.gray
                            }
                        }.frame(height: 200, alignment: .center)
                            .clipped()
                    }
                }.navigationTitle("Example Content")
            }
            .modifier(ErrorableViewModifier(pageState: $pageState) {
                DefaultErrorView(type: .sheet) {
                    pageState = .loading
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        pageState = .successful
                    }
                }
            })
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    pageState = .failure
                }
            }
    }
}

#Preview {
    if #available(iOS 15.0, *) {
        TestView()
    } else {
       EmptyView()
    }
}
