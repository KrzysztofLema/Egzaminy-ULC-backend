import Fluent
import Vapor

struct SubjectController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let subjectsRoutes = routes.grouped("api", "subjects")
        
        subjectsRoutes.get(":examID", use: getAllSubjectsByExamIDHandler)
    }
    
    @Sendable
    func getAllSubjectsByExamIDHandler(_ req: Request) async throws -> [Subject] {
        guard let examID = req.parameters.get("examID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid exam ID")
        }
        
        return try await Subject.query(on: req.db)
            .filter(\.$exam.$id == examID)
            .all()
    }
}
