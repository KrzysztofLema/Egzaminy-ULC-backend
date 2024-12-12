//
//  CreateAnwser.swift
//  template-fluent-postgres
//
//  Created by Krzysztof Lema on 11/12/2024.
//

import Fluent

struct CreateAnwser: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("anwsers")
            .id()
            .field("anwserText", .string, .required)
            .field("isCorrect",.bool, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("anwsers").delete()
    }
}
