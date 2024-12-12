//
//  CreateQuestion.swift
//  template-fluent-postgres
//
//  Created by Krzysztof Lema on 11/12/2024.
//

import Fluent

struct CreateQuestion: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("questions")
            .id()
            .field("question_number", .string, .required)
            .field("title", .string, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("questions").delete()
    }
}
