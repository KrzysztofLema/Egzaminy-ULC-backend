import Fluent
import Vapor

struct QuestionController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let subjectsRoutes = routes.grouped("api", "questions")
        
        subjectsRoutes.get(":subjectID", use: getAllQuestionsBySubjectIDHandler)
    }
    
    @Sendable
    func getAllQuestionsBySubjectIDHandler(_ req: Request) async throws -> [Question] {
        guard let subjectID = req.parameters.get("subjectID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid subject ID")
        }
        
        return try await Question.query(on: req.db)
            .filter(\.$subject.$id == subjectID)
            .with(\.$answers)
            .all()
    }
}
