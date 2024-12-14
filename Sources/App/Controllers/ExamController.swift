import Fluent
import Vapor

struct ExamController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let examsRoutes = routes.grouped("api", "exams")

        examsRoutes.get(use: getAllHandler)
        examsRoutes.post(use: createHandler)
    }

    @Sendable
    func getAllHandler(_ req: Request) async throws -> [ExamDTO] {
        try await Exam.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func createHandler(_ req: Request) async throws -> ExamDTO {
        let exam = try req.content.decode(ExamDTO.self).toModel()

        try await exam.save(on: req.db)

        return exam.toDTO()
    }
}
