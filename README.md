# ErrorableView-SwiftUI
 
## How to install this package 

+ Open your project on Xcode
+ Go to the Project Tab and select "Package Dependencies"
+ Click "+" and search this package with use git clone URL
+ Don't change anything and click Add Package
+ The package will be attached to the targeted application

## How to use this package
### Create a ViewModel conforming to the ErrorableBaseViewModel
<b>Note:<b> The class includes AnyObject and ObservableObject!

```swift
private final class ExampleViewModel: ErrorableBaseViewModel {
    // Your actions will come here
}
```
### Create some SwiftUI view that conforms to the ErrorableView
```swift
@available(iOS 15.0, *)
private struct ExampleContentView: View {
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
    }
}

@available(iOS 15.0, *)
private struct OnPageExampleView: ErrorableView {
    @ObservedObject var viewModel: ExampleViewModel = ExampleViewModel()

    var content: some View {
        ExampleContentView()
    }
    
    var errorStateConfigModel: ErrorStateConfigureModel {
        ErrorStateConfigureModel.Builder()
            .buttonAction {
                viewModel.refreshPage()
            }.build()
    }
}

@available(iOS 15.0, *)
private struct SheetExampleView: ErrorableView {
    @ObservedObject var viewModel: ExampleViewModel = ExampleViewModel()

    var content: some View {
        ExampleContentView()
    }
    
    var errorStateConfigModel: ErrorStateConfigureModel {
        ErrorStateConfigureModel.Builder()
            .buttonAction {
                viewModel.refreshPage()
            }.build()
    }
    
    var errorPresentType: ErrorPresentTypes { .sheet }
}

@available(iOS 15.0, *)
private struct FullScreenExampleView: ErrorableView {
    @ObservedObject var viewModel: ExampleViewModel = ExampleViewModel()

    var content: some View {
        ExampleContentView()
    }
    
    var errorStateConfigModel: ErrorStateConfigureModel {
        ErrorStateConfigureModel.Builder()
            .buttonAction {
                viewModel.refreshPage()
            }.build()
    }
    
    var errorPresentType: ErrorPresentTypes { .fullScreen }
}
```

## Sheet Type
https://github.com/devmehmetates/ErrorableView-SwiftUI/assets/74152011/1fe9e28a-8ba3-48b8-8d85-b2eb4c6aa672

## OnPage Type
https://github.com/devmehmetates/ErrorableView-SwiftUI/assets/74152011/2c579c96-adec-4d6e-9739-1892d97666aa

## Fullscreen Type
https://github.com/devmehmetates/ErrorableView-SwiftUI/assets/74152011/6e34332f-6c24-489d-8bd2-bfd5ab2fb027
