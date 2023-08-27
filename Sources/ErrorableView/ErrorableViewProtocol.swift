//
//  ErrorableViewModelProtocol.swift
//
//
//  Created by Mehmet Ateş on 26.08.2023.
//

import SwiftUI

@available(macOS 11.0, *)
@available(iOS 14.0, *)
public protocol ErrorableViewProtocol: View where ViewModel: ErrorableViewModelProtocol {
    associatedtype ViewModel
    associatedtype Content

    var viewModel: ViewModel { get set }
}

@available(macOS 11.0, *)
@available(iOS 14.0, *)
public extension ErrorableViewProtocol where Content == AnyView {
    func createErrorableView(
        @ViewBuilder loadingView: () -> Content,
        @ViewBuilder failureView: () -> Content,
        @ViewBuilder successfulView: () -> Content
    ) -> Content {
        switch viewModel.state {
        case .loading:
            return loadingView()
        case .successful:
            return successfulView()
        case .failure:
            return failureView()
        }
    }

    func createErrorableView(
        @ViewBuilder failureView: () -> Content,
        @ViewBuilder successfulView: () -> Content
    ) -> Content {
        switch viewModel.state {
        case .loading:
            return loadingState
        case .successful:
            return successfulView()
        case .failure:
            return failureView()
        }
    }

    func createErrorableView(
        errorTitle: LocalizedStringKey,
        errorSubTitle: LocalizedStringKey? = nil,
        errorIcon: String? = nil,
        errorSystemIcon: String? = nil,
        errorButtonTitle: LocalizedStringKey,
        @ViewBuilder successfulView: () -> Content
    ) -> Content {
        switch viewModel.state {
        case .loading:
            return loadingState
        case .successful:
            return successfulView()
        case .failure:
            return failuteState(errorTitle: errorTitle, errorSubTitle: errorSubTitle, errorIcon: errorIcon, errorSystemIcon: errorSystemIcon, errorButtonTitle: errorButtonTitle)
        }
    }
    
    private var loadingState: Content {
        AnyView(
            VStack {
                Spacer()
                ProgressView()
                    .accentColor(.accentColor)
                Spacer()
            }
        )
    }
    
    private func failuteState(
        errorTitle: LocalizedStringKey,
        errorSubTitle: LocalizedStringKey?,
        errorIcon: String?,
        errorSystemIcon: String?,
        errorButtonTitle: LocalizedStringKey
    ) -> Content {
        AnyView(
            VStack {
                Spacer()
                if let errorSystemIcon {
                    Image(systemName: errorSystemIcon)
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                }
                
                if let errorIcon {
                    Image(errorIcon)
                }
                
                Text(errorTitle)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                if let errorSubTitle {
                    Text(errorSubTitle)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                Button {
                    viewModel.refresh()
                } label: {
                    Text(errorButtonTitle)
                        .padding()
                        .background(Color.red.opacity(0.3))
                }.accentColor(Color.red)
                    .clipShape(Capsule())
                Spacer()
            }
        )
    }
}

@available(macOS 11.0, *)
@available(iOS 15.0, *)
private struct Example_Preview: PreviewProvider {
    static var previews: some View {
        Example()
    }
}

@available(macOS 11.0, *)
@available(iOS 15.0, *)
private struct Example: ErrorableViewProtocol {
    typealias Content = AnyView
    typealias ViewModel = ExampleViewModel
    @ObservedObject var viewModel: ExampleViewModel = ExampleViewModel()

    var body: some View {
        NavigationView {
            createErrorableView(errorTitle: "Upps!", errorSubTitle: "We encountered an error.\n Please try again later!", errorSystemIcon: "minus.diamond.fill", errorButtonTitle: "Try Again") {
                AnyView (
                    ScrollView {
                        ForEach(0..<100, id: \.self) { _ in
                            AsyncImage(url: URL(string: "https://picsum.photos/200")) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    Color.gray
                                }
                            }.frame(width: 300, height: 200, alignment: .center)
                        }
                    }
                )
            }
            .navigationTitle("Example")
        }.onAppear {
            Task { @MainActor in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    viewModel.state = .failure
                }
            }
        }
    }
}

@available(macOS 11.0, *)
@available(iOS 15.0, *)
private final class ExampleViewModel: ErrorableViewModelProtocol {
    @Published var state: PageStates = .loading
    func refresh() {
        state = .successful
    }
}
