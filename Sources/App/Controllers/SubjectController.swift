import Fluent
import Vapor

struct SubjectController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let subjectsRoutes = routes.grouped("api", "subjects")
        

        subjectsRoutes.get("", use: getAllSubjectsByExamIDHandler)
    }

    @Sendable
    func getAllSubjectsByExamIDHandler(_ req: Request) async throws -> [Subject] {
        guard let examIDString = req.query[String.self, at: "examID"],
              let examID = UUID(uuidString: examIDString) else {
            throw Abort(.badRequest, reason: "Invalid or missing examID query parameter")
        }

        return try await Subject.query(on: req.db)
            .filter(\.$exam.$id == examID)
            .all()
    }
}
