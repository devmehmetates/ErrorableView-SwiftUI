//
//  ErrorableViewModelProtocol.swift
//
//
//  Created by Mehmet Ateş on 26.08.2023.
//

import SwiftUI

/**
 A protocol that defines the requirements for a view that can display content and handle error states using a view model.

 Conforming to the `ErrorableViewProtocol` allows a view to display both regular content and error states using a specified view model and error state configuration model.

 - Parameters:
   - ViewModel: A generic associated type representing the view model associated with the view.
   - Content: A generic associated type representing the content that can be displayed within the view.

 This protocol requires the conforming view to provide a content view using a `ViewBuilder`, a view model, and an error state configuration model. It is typically used to create views that can gracefully handle and display errors while presenting content.

 - Note: Conforming Other Protocols to ErrorableViewProtocol

    In some cases, you may want to create more specific protocols that conform to the ErrorableViewProtocol. Two such protocols are ErrorableView and ErrorableSheetView. When these protocols conform to ErrorableViewProtocol, it's essential to consider their unique use cases and requirements.

 - **ErrorableView Protocol**:
    The ErrorableView protocol extends the ErrorableViewProtocol and specializes it for specific scenarios, adding further requirements or custom behavior tailored to your needs. You should use the ErrorableView protocol when you require a more specialized view that can handle errors and content in a way that aligns with your project's requirements.
 - **ErrorableSheetView Protocol**:
    The ErrorableSheetView protocol is designed to work with SwiftUI's Sheet presentation style. It allows you to create views that can display content and handle error states when presented as a sheet. By conforming to the ErrorableViewProtocol, you can ensure consistency in error handling across different parts of your app that utilize sheet presentations.

 Extension for the `ErrorableViewProtocol` protocol providing a default error state configuration model.

 This extension offers a default error state configuration for views conforming to the `ErrorableViewProtocol`. The error state configuration includes a title, subtitle, system image name, button title, and associated actions to handle the error state.

 - Returns:
   An instance of `ErrorStateConfigureModel` with the following default values:
   - Title: "Error!"
   - Subtitle: "We encountered an error. Please try again later!"
   - System Image Name: "exclamationmark.triangle"
   - Button Title: "Try Again!"
   - Button Action: When the "Try Again!" button is tapped, it sets the associated view model's `pageState` to `.loading`.
   - Dismiss Action: When the error state is dismissed, it also sets the associated view model's `pageState` to `.loading`.

 This default error state configuration simplifies the handling of error states for views conforming to the `ErrorableViewProtocol`. Conforming views can use this default configuration or provide their custom error state configuration by implementing the `errorStateConfigModel` property in their own way.

 ### Example Usage:
 ```swift
 @available(iOS 15.0, *)
 private struct SimpleExampleView: ErrorableView {
     typealias ViewModel = ExampleViewModel
     @ObservedObject var viewModel: ExampleViewModel = ExampleViewModel()

     var content: some View {
         VStack {
             Text("Loaded Statement!")
         }
     }
 }
 ```
 - Note:
 This default configuration is a convenient starting point and ensures a consistent error state representation across views that conform to the ErrorableViewProtocol. However, it can be overridden or customized as needed when defining specific views.
 - SeeAlso: `ErrorableViewProtocol`, `ErrorStateConfigureModel`
 */
public protocol ErrorableViewProtocol: View where Body: View, ViewModel: ErrorableBaseViewModel {
    associatedtype ViewModel
    associatedtype Content

    /// A view builder for the content to be displayed within the view.
    @ViewBuilder var content: Self.Content { get }

    /// The view model associated with the view.
    var viewModel: ViewModel { get }

    /// The configuration model for error state handling within the view.
    var errorStateConfigModel: ErrorStateConfigureModel { get }
}

public extension ErrorableViewProtocol {
    var errorStateConfigModel: ErrorStateConfigureModel {
        ErrorStateConfigureModel.Builder()
            .title("Error!")
            .subtitle("We encountered an error.\n Please try again later!")
            .systemName("exclamationmark.triangle")
            .buttonTitle("Try Again!")
            .buttonAction {
                viewModel.pageState = .loading
            }.dismissAction {
                viewModel.pageState = .loading
            }.build()
    }
}

open class ErrorableBaseViewModel: ObservableObject {
    @Published var pageState: PageStates = .loading
}

public protocol ErrorableSheetView: ErrorableViewProtocol {}

public extension ErrorableSheetView where Content: View {
    var body: some View {
        VStack {
            if viewModel.pageState == .loading {
                LoadingStateView()
            } else if viewModel.pageState == .successful {
                content
            }
        }.sheet(
            isPresented: .constant(viewModel.pageState == .failure),
            onDismiss: errorStateConfigModel.dismissAction
        ) {
            NavigationView {
                ErrorStateView(model: errorStateConfigModel)
                    .toolbar {
                        Button {
                            errorStateConfigModel.buttonAction?()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title3)
                        }.accentColor(.secondary)
                    }
            }
        }
    }
}

public protocol ErrorableView: ErrorableViewProtocol {}

public extension ErrorableView where Content: View {
    var body: some View {
        VStack {
            if viewModel.pageState == .loading {
                LoadingStateView()
            } else if viewModel.pageState == .failure {
                ErrorStateView(model: errorStateConfigModel)
            } else {
                content
            }
        }
    }
}

@frozen public struct ErrorStateConfigureModel {
    var title: LocalizedStringKey
    var subtitle: LocalizedStringKey?
    var icon: String?
    var systemName: String?
    var buttonTitle: LocalizedStringKey?
    var dismissAction: (() -> Void)?
    var buttonAction: (() -> Void)?
    
    public class Builder {
        private var title: LocalizedStringKey = "Error!"
        private var subtitle: LocalizedStringKey?
        private var icon: String?
        private var systemName: String?
        private var buttonTitle: LocalizedStringKey?
        private var buttonAction: (() -> Void)?
        private var dismissAction: (() -> Void)?

        @discardableResult
        func title(_ title: LocalizedStringKey) -> Self {
            self.title = title
            return self
        }
        
        @discardableResult
        func subtitle(_ subtitle: LocalizedStringKey?) -> Self {
            self.subtitle = subtitle
            return self
        }
        
        @discardableResult
        func icon(_ icon: String?) -> Self {
            self.icon = icon
            return self
        }
        
        @discardableResult
        func systemName(_ systemName: String?) -> Self {
            self.systemName = systemName
            return self
        }
        
        @discardableResult
        func buttonTitle(_ buttonTitle: LocalizedStringKey?) -> Self {
            self.buttonTitle = buttonTitle
            return self
        }
        
        @discardableResult
        func dismissAction(_ dismissAction: (() -> Void)?) -> Self {
            self.dismissAction = dismissAction
            return self
        }

        @discardableResult
        func buttonAction(_ buttonAction: (() -> Void)?) -> Self {
            self.buttonAction = buttonAction
            return self
        }
        
        func build() -> ErrorStateConfigureModel {
            ErrorStateConfigureModel(
                title: title,
                subtitle: subtitle,
                icon: icon,
                systemName: systemName,
                buttonTitle: buttonTitle,
                dismissAction: dismissAction,
                buttonAction: buttonAction
            )
        }
    }
}

@frozen public struct ErrorStateView: View {
    var model: ErrorStateConfigureModel
    
    public var body: some View {
        VStack {
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
        }
    }
}

@frozen public struct LoadingStateView: View {
    public var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading...")
                .font(.caption)
                .padding(.top)
        }
    }
}

@frozen public struct ErrorStateButtonModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .padding(.vertical, 5)
            .foregroundColor(.primary)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

@frozen public enum PageStates {
    case loading
    case successful
    case failure
}

private final class ExampleViewModel: ErrorableBaseViewModel {
    override init() {
        super.init()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.pageState = .failure
        }
    }
    
    func refreshPage() {
        self.pageState = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.pageState = .successful
        }
    }
}

@available(iOS 15.0, *)
private struct ExampleView: ErrorableSheetView {
    typealias ViewModel = ExampleViewModel
    @ObservedObject var viewModel: ExampleViewModel = ExampleViewModel()

    var content: some View {
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
            }.navigationTitle("Example")
        }
    }
    
    var errorStateConfigModel: ErrorStateConfigureModel {
        ErrorStateConfigureModel.Builder()
            .title("Error!")
            .subtitle("We encountered an error.\n Please try again later!")
            .systemName("exclamationmark.triangle")
            .buttonTitle("Try Again!")
            .buttonAction {
                viewModel.refreshPage()
            }.dismissAction{
                viewModel.refreshPage()
            }.build()
    }
}

@available(iOS 15.0, *)
private struct SimpleExampleView: ErrorableView {
    typealias ViewModel = ExampleViewModel
    @ObservedObject var viewModel: ExampleViewModel = ExampleViewModel()

    var content: some View {
        VStack {
            Text("Loaded Statement!")
        }
    }
}

@available(iOS 15.0, *)
#Preview {
    ExampleView()
}
