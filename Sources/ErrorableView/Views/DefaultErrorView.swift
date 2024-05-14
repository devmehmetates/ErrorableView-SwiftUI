//
//  DefaultErrorView.swift
//
//
//  Created by Mehmet Ateş on 24.11.2023.
//

import SwiftUI

public protocol ErrorableView: View {
    var type: ErrorPresentTypes { get set }
}

@frozen public struct DefaultErrorView: ErrorableView {
    @Environment(\.dismiss) private var dismiss
    @Binding private var state: PageStates
    private var uimodel: DefaultErrorPageUIModel
    private var buttonAction: (() -> Void)?
    public var type: ErrorPresentTypes

    public init(
        uimodel: DefaultErrorPageUIModel = .Builder().build(),
        type: ErrorPresentTypes = .sheet,
        state: Binding<PageStates>,
        buttonAction: (() -> Void)? = nil
    ) {
        self.uimodel = uimodel
        self.type = type
        self.buttonAction = buttonAction
        self._state = state
    }

    public var body: some View {
        VStack {
            closeButtonView
            Spacer()

            VStack {
                iconImageView
                    .imageScale(.large)
                    .font(.largeTitle)

                Text(uimodel.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom)

            subTitleView

            Spacer()

            buttonView
        }.padding(.vertical)
    }
}

// MARK: - UIComponents
private extension DefaultErrorView {
    @ViewBuilder
    var closeButtonView: some View {
        if type != .onPage {
            HStack {
                Spacer()
                Button {
                    buttonAction?()
                    state = .loading
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                }.accentColor(.secondary)
            }.padding(.horizontal)
        }
    }

    @ViewBuilder
    var iconImageView: some View {
        if let icon = uimodel.icon {
            Image(icon)
        } else if let systemName = uimodel.systemName {
            Image(systemName: systemName)
        }
    }

    @ViewBuilder
    var subTitleView: some View {
        if let subtitle = uimodel.subtitle {
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
    }

    @ViewBuilder
    var buttonView: some View {
        if let buttonTitle = uimodel.buttonTitle {
            if #available(iOS 15.0, *) {
                Button {
                    buttonAction?()
                    state = .loading
                    dismiss()
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
                    buttonAction?()
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

// MARK: - UIModel
@frozen public struct DefaultErrorPageUIModel {
    var title: LocalizedStringKey
    var subtitle: LocalizedStringKey?
    var icon: String?
    var systemName: String?
    var buttonTitle: LocalizedStringKey?

    public class Builder {
        private var type: ErrorPresentTypes = .sheet
        private var title: LocalizedStringKey = "Error!"
        private var subtitle: LocalizedStringKey? = "We encountered an error.\n Please try again later!"
        private var icon: String?
        private var systemName: String? = "externaldrive.fill.trianglebadge.exclamationmark"
        private var buttonTitle: LocalizedStringKey? = "Try Again!"

        public init() {}

        @discardableResult
        public func type(_ type: ErrorPresentTypes) -> Self {
            self.title = title
            return self
        }

        @discardableResult
        public func title(_ title: LocalizedStringKey) -> Self {
            self.title = title
            return self
        }

        @discardableResult
        public func subtitle(_ subtitle: LocalizedStringKey?) -> Self {
            self.subtitle = subtitle
            return self
        }

        @discardableResult
        public func icon(_ icon: String?) -> Self {
            self.icon = icon
            return self
        }

        @discardableResult
        public func systemName(_ systemName: String?) -> Self {
            self.systemName = systemName
            return self
        }

        @discardableResult
        public func buttonTitle(_ buttonTitle: LocalizedStringKey?) -> Self {
            self.buttonTitle = buttonTitle
            return self
        }

        public func build() -> DefaultErrorPageUIModel {
            DefaultErrorPageUIModel(
                title: title,
                subtitle: subtitle,
                icon: icon,
                systemName: systemName,
                buttonTitle: buttonTitle
            )
        }
    }
}

// MARK: - ViewModifer(s)
@frozen public struct ErrorStateButtonModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .padding(.vertical, 5)
            .foregroundColor(.primary)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    DefaultErrorView(state: .constant(.loading))
}
