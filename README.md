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
### Create a SwiftUI view that conforms to the ErrorableView or ErrorableSheetView Protocols. (Usage is the same for both protocols.)
```swift
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

## ErrorableView Demo Images
<div>
  <img width = 255 height = 525 src="https://github.com/devmehmetates/ErrorableView-SwiftUI/assets/74152011/5dc340f8-e455-46f9-9504-e3fcc6faf3a5">
  <img width = 255 height = 525 src="https://github.com/devmehmetates/ErrorableView-SwiftUI/assets/74152011/f4c4b650-87fb-4b51-a305-c550ba2db85b">
  <img width = 255 height = 525 src="https://github.com/devmehmetates/ErrorableView-SwiftUI/assets/74152011/f28af8bb-dea2-4581-9770-ce7879e99925">
</div>

## ErrorableSheetView Demo Images
<div>
  <img width = 255 height = 525 src="https://github.com/devmehmetates/ErrorableView-SwiftUI/assets/74152011/5dc340f8-e455-46f9-9504-e3fcc6faf3a5">
  <img width = 255 height = 525 src="https://github.com/devmehmetates/ErrorableView-SwiftUI/assets/74152011/3631f105-c1c2-4b71-9895-6a442e2b2dca">
  <img width = 255 height = 525 src="https://github.com/devmehmetates/ErrorableView-SwiftUI/assets/74152011/f28af8bb-dea2-4581-9770-ce7879e99925">
</div>
