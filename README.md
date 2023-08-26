# ErrorableView-SwiftUI
 
## How to install this package 

+ Open your project on Xcode
+ Go to Project Tab and select "Package Dependencies"
+ Click "+" and search this package with use git clone url
+ Don't change anything and click Add Package
+ The package will be attached to the targeted application

## How to use this package
### Create a ViewModel conforming to the ErrorableViewModelProtocol
<b>Note:<b> The class includes AnyObject and ObservableObject!

```swift
final class TestViewModel: ErrorableViewModelProtocol {
    @Published var state: PageStates = .loading

    func refresh() {
        // TODO: Write here your refresh action
        // TODO: Don't forget to update the state property in the refresh action
    }
}
```
### Create SwiftUI and conform to the ErrorableViewProtocol
- Set the ViewModel typealias to the view model we created
- Create the Viewmodel as @ObservedObject.
- Use the createErrorableView function according to your need.
```swift
struct ContentView: ErrorableViewProtocol {
    typealias Content = AnyView
    typealias ViewModel = TestViewModel
    @ObservedObject var viewModel: TestViewModel = TestViewModel()
    
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
                                .clipped()
                        }
                    }.frame(width: UIScreen.main.bounds.width)
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
```

## Demo Images
<div>
  <img width = 255 src="https://github.com/devmehmetates/ErrorableView-SwiftUI/assets/74152011/69b5fcd7-dc27-4c84-ab28-f258f3a2d96d">
  <img width = 255 src="https://github.com/devmehmetates/ErrorableView-SwiftUI/assets/74152011/ea08d457-d440-496f-a84f-9636611854a0">
  <img width = 255 src="https://github.com/devmehmetates/ErrorableView-SwiftUI/assets/74152011/69a47f0d-95c4-4375-9aea-583c85fc9688">
</div>
