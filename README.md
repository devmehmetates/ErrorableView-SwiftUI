# ErrorableView-SwiftUI
 
## How to install this package 

+ Open your project on Xcode
+ Go to the Project Tab and select "Package Dependencies"
+ Click "+" and search this package with use git clone URL
+ Don't change anything and click Add Package
+ The package will be attached to the targeted application

## How to use this package
### Just use The "ErrorableViewModifier" with an $pageState property
```swift
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
            .modifier(ErrorableViewModifier(pageState: $pageState) { // Like this
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
```
## Useful Tips
This package allows you to manage your page error state easily. But actually, it's useful. What do you get to know?

- Generic Error Page Support:
  The Package includes a DefaultErrorPage but you don't want to use it. Use the ErrorableView protocol, and create your error page.
```swift
protocol ErrorableView: View {
   var type: ErrorPresentTypes { get set }
}
```
This protocol only wants to create a type property for your error page presentation state. If your view comformed the protocol you'll use this modifier code block under the below.
```swift
.modifier(ErrorableViewModifier(pageState: $viewModel.pageState) { // Like this
    YourView() {
         viewModel.reload()
    }
})
```
- Fully Customisable Error Page:
The package includes a customizable ErrorPage named DefaultErrorPage. You can use that uiModel to update DefaultErrorPage.
```swift
@frozen public struct DefaultErrorPageUIModel {
    var title: LocalizedStringKey
    var subtitle: LocalizedStringKey?
    var icon: String?
    var systemName: String?
    var buttonTitle: LocalizedStringKey?
}
```

## Examples 
### Sheet Type
https://github.com/devmehmetates/ErrorableView-SwiftUI/assets/74152011/1fe9e28a-8ba3-48b8-8d85-b2eb4c6aa672

### OnPage Type
https://github.com/devmehmetates/ErrorableView-SwiftUI/assets/74152011/2c579c96-adec-4d6e-9739-1892d97666aa

### Fullscreen Type
https://github.com/devmehmetates/ErrorableView-SwiftUI/assets/74152011/6e34332f-6c24-489d-8bd2-bfd5ab2fb027
