//
//  CreateExam.swift
//  template-fluent-postgres
//
//  Created by Krzysztof Lema on 09/12/2024.
//

import Fluent

struct CreateExam: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("exams")
            .id()
            .field("title", .string, .required)
            .field("subtitle",.string,.required)
            .field("text",.string,.required)
            .field("image",.string,.required)
            .field("background",.string,.required)
            .field("logo",.string,.required)
            .create()
        
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("exams").delete()
    }
}


    
