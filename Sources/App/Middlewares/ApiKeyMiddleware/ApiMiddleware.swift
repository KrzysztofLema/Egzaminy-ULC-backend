//
//  ApiMiddleware.swift
//  template-fluent-postgres
//
//  Created by Krzysztof Lema on 17/12/2024.
//

import Vapor

struct ApiMiddleware: AsyncMiddleware {
    public var key: String

    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        guard let apiKey = request.headers.apiKey else {
            throw Abort(.notFound, reason: "Missing Api Key")
        }

        guard apiKey.value == key else {
            throw Abort(.unauthorized, reason: "Invalid Api Key")
        }

        return try await next.respond(to: request)
    }
}
