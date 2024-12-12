//
//  CreateSubject.swift
//  template-fluent-postgres
//
//  Created by Krzysztof Lema on 11/12/2024.
//

import Fluent

struct CreateSubject: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("subjects")
            .id()
            .field("title", .string, .required)
            .field("image", .string, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("subjects").delete()
    }
}
