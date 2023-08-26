//
//  ErrorableViewModelProtocol.swift
//  
//
//  Created by Mehmet Ateş on 26.08.2023.
//

import Combine

@available(macOS 10.15, *)
@available(iOS 13.0, *)
public protocol ErrorableViewModelProtocol: AnyObject, ObservableObject {
    var state: PageStates { get set }
    func refresh()
}
