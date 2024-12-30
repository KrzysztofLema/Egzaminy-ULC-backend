import Fluent
import Vapor

struct QuestionController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let subjectsRoutes = routes.grouped("api", "questions")
        
        subjectsRoutes.get("", use: getAllQuestionsBySubjectIDHandler)
    }
    
    @Sendable
    func getAllQuestionsBySubjectIDHandler(_ req: Request) async throws -> [Question] {
        guard let subjectIDString = req.query[String.self, at: "subjectID"],
              let subjectID = UUID(uuidString: subjectIDString) else {
            throw Abort(.badRequest, reason: "Invalid or missing subjectID query parameter")
        }
        
        return try await Question.query(on: req.db)
            .filter(\.$subject.$id == subjectID)
            .with(\.$answers)
            .all()
    }
}
