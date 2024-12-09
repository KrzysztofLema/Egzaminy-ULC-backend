//
//  ExamController.swift
//  template-fluent-postgres
//
//  Created by Krzysztof Lema on 09/12/2024.
//

import Fluent
import Vapor

struct ExamController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
      let examsRoutes = routes.grouped("api","exams")
        
        examsRoutes.get(use: getAllHandler)
        examsRoutes.post(use: createHandler)
    }
    
    @Sendable
    func getAllHandler(_ req: Request) async throws -> [Exam] {
        try await Exam.query(on: req.db).all()
    }
    
    @Sendable
    func createHandler(_ req: Request) async throws -> Exam  {
        let data = try req.content.decode(CreateExamData.self)
        let exam = Exam(
            title: data.title,
            subtitle: data.subtitle,
            text: data.text,
            image: data.image,
            background: data.background,
            logo: data.logo
        )
        try await exam.save(on: req.db)
        return exam
    }
}

struct CreateExamData: Content {
    let title: String
    let subtitle: String
    let text: String
    let image: String
    let background: String
    let logo: String
}
