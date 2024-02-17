//
//  ErrorableView.swift
//
//
//  Created by Mehmet Ateş on 24.11.2023.
//

import SwiftUI

public protocol ErrorableViewP: View where Presenter: ErrorableBasePresenter {
    associatedtype Presenter
    associatedtype Content: View
    associatedtype LoadingContent: View
    associatedtype ErrorContent: View
    
    var presenter: Presenter { get }
    @ViewBuilder var content: Self.Content { get }
    @ViewBuilder var loadingContent: Self.LoadingContent { get }
    @ViewBuilder var errorContent: Self.ErrorContent { get }
    var errorStateConfigModel: ErrorStateConfigureModel { get }
    var errorPresentType: ErrorPresentTypes { get }
}

public protocol ErrorableView: View where ViewModel: ErrorableBaseViewModel {
    associatedtype ViewModel
    associatedtype Content: View
    associatedtype LoadingContent: View
    associatedtype ErrorContent: View
    
    var viewModel: ViewModel { get }
    @ViewBuilder var content: Self.Content { get }
    @ViewBuilder var loadingContent: Self.LoadingContent { get }
    @ViewBuilder var errorContent: Self.ErrorContent { get }
    var errorStateConfigModel: ErrorStateConfigureModel { get }
    var errorPresentType: ErrorPresentTypes { get }
}

public extension ErrorableView {
    var body: some View {
        ZStack {
            switch errorPresentType {
            case .onPage:
                onPageConfiguration()
            case .fullScreen:
                fullScreenConfiguration()
            case .sheet:
                sheetConfiguration()
            }
        }.animation(.spring, value: viewModel.pageState)
    }
    
    @ViewBuilder var loadingContent: some View {
        DefaultLoadingView()
    }
    
    @ViewBuilder var errorContent: some View {
        DefaultErrorView(model: errorStateConfigModel, type: errorPresentType)
    }
    
    var errorStateConfigModel: ErrorStateConfigureModel {
        ErrorStateConfigureModel
            .Builder()
            .build()
    }
    
    var errorPresentType: ErrorPresentTypes { .onPage }
}

fileprivate extension ErrorableView {
    @ViewBuilder func onPageConfiguration() -> some View {
        Group {
            if viewModel.pageState == .loading {
                loadingContent
            } else if viewModel.pageState == .failure {
                errorContent
            } else {
                content
            }
        }
    }

    @ViewBuilder func fullScreenConfiguration() -> some View {
        Group {
            if viewModel.pageState == .successful {
                content
            } else  {
                loadingContent
            }
        }.fullScreenCover(isPresented: .init(get: { viewModel.sheetsOpen }, set: { newValue in viewModel.sheetsOpen = newValue })) {
            errorContent
        }
        .onChange(of: viewModel.pageState) { newValue in
            viewModel.sheetsOpen = newValue == .failure
        }
    }

    @ViewBuilder func sheetConfiguration() -> some View {
        Group {
            if viewModel.pageState == .successful {
                content
            } else  {
                loadingContent
            }
        }.sheet(isPresented: .init(get: { viewModel.sheetsOpen }, set: { newValue in viewModel.sheetsOpen = newValue }), onDismiss: errorStateConfigModel.buttonAction) {
            errorContent
        }
        .onChange(of: viewModel.pageState) { newValue in
            viewModel.sheetsOpen = newValue == .failure
        }
    }
}

public extension ErrorableViewP {
    var body: some View {
        ZStack {
            switch errorPresentType {
            case .onPage:
                onPageConfiguration()
            case .fullScreen:
                fullScreenConfiguration()
            case .sheet:
                sheetConfiguration()
            }
        }.animation(.spring, value: presenter.pageState)
    }
    
    @ViewBuilder var loadingContent: some View {
        DefaultLoadingView()
    }
    
    @ViewBuilder var errorContent: some View {
        DefaultErrorView(model: errorStateConfigModel, type: errorPresentType)
    }
    
    var errorStateConfigModel: ErrorStateConfigureModel {
        ErrorStateConfigureModel
            .Builder()
            .build()
    }
    
    var errorPresentType: ErrorPresentTypes { .onPage }
}

fileprivate extension ErrorableViewP {
    @ViewBuilder func onPageConfiguration() -> some View {
        Group {
            if presenter.pageState == .loading {
                loadingContent
            } else if presenter.pageState == .failure {
                errorContent
            } else {
                content
            }
        }
    }

    @ViewBuilder func fullScreenConfiguration() -> some View {
        Group {
            if presenter.pageState == .successful {
                content
            } else  {
                loadingContent
            }
        }.fullScreenCover(isPresented: .init(get: { presenter.sheetsOpen }, set: { newValue in presenter.sheetsOpen = newValue })) {
            errorContent
        }
        .onChange(of: presenter.pageState) { newValue in
            presenter.sheetsOpen = newValue == .failure
        }
    }

    @ViewBuilder func sheetConfiguration() -> some View {
        Group {
            if presenter.pageState == .successful {
                content
            } else  {
                loadingContent
            }
        }.sheet(isPresented: .init(get: { presenter.sheetsOpen }, set: { newValue in presenter.sheetsOpen = newValue }), onDismiss: errorStateConfigModel.buttonAction) {
            errorContent
        }
        .onChange(of: presenter.pageState) { newValue in
            presenter.sheetsOpen = newValue == .failure
        }
    }
}
