//
//  ApiKey.swift
//  template-fluent-postgres
//
//  Created by Krzysztof Lema on 17/12/2024.
//

import Vapor

public struct ApiKey: Equatable, Sendable {
    public let value: String

    public init(value: String) {
        self.value = value
    }
}

extension ApiKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.value = value
    }
}

extension HTTPHeaders.Name {
    static let apiKey = HTTPHeaders.Name("X-API-KEY")
}

public extension HTTPHeaders {
    var apiKey: ApiKey? {
        get {
            guard let string = first(name: .apiKey) else {
                return nil
            }

            return .init(value: string)
        }
        set {
            if let apiKey = newValue {
                replaceOrAdd(name: .apiKey, value: apiKey.value)
            } else {
                remove(name: .apiKey)
            }
        }
    }
}
