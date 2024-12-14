import Fluent
import Vapor

struct ExamController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let examsRoutes = routes.grouped("api", "exams")

        let tokenAuthMiddleware = Token.authenticator()
        let guardAuthMiddleware = User.guardMiddleware()

        let tokenAuthGroup = examsRoutes.grouped(
            tokenAuthMiddleware,
            guardAuthMiddleware
        )

        tokenAuthGroup.post(use: createHandler)
        tokenAuthGroup.get(use: getAllHandler)
    }

    @Sendable
    func getAllHandler(_ req: Request) async throws -> [Exam] {
        try await Exam
            .query(on: req.db)
            .with(\.$subjects)
            .all()
    }

    @Sendable
    func createHandler(_ req: Request) async throws -> Exam {
        let examData = try req.content.decode(CreateExamData.self)
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()

        // Create and save the Exam
        let exam = Exam(
            title: examData.title,
            subtitle: examData.subtitle,
            text: examData.text,
            image: examData.image,
            background: examData.background,
            logo: examData.logo,
            userID: userID
        )
        try await exam.save(on: req.db)

        // Create and save the Subjects
        let subjects = examData.subjects.map { subjectData in
            Subject(title: subjectData.title, image: subjectData.image, examID: try! exam.requireID())
        }

        try await exam.$subjects.create(subjects, on: req.db)
        return exam
    }

    @Sendable
    func updateHandler(_ req: Request) async throws -> Exam {
        let updatedExam = try req.content.decode(CreateExamData.self)
        guard let exam = try await Exam.find(req.parameters.get("examID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()

        exam.title = updatedExam.title
        exam.subtitle = updatedExam.subtitle
        exam.text = updatedExam.text
        exam.image = updatedExam.image
        exam.background = updatedExam.logo
        exam.logo = updatedExam.logo
        exam.$user.id = userID

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
    let subjects: [CreateSubjectData]
}

struct CreateSubjectData: Content {
    let title: String
    let image: String
}
