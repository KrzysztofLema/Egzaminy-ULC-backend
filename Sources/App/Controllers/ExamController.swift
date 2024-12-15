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
            .with(\.$subjects) { subject in
                subject.with(\.$questions) { question in
                    question.with(\.$answers)
                }
            }
            .all()
    }

    @Sendable
    func createHandler(_ req: Request) async throws -> HTTPStatus {
        let examData = try req.content.decode(CreateExamData.self)
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()

        return try await req.db.transaction { database in
            let exam = Exam(
                title: examData.title,
                subtitle: examData.subtitle,
                text: examData.text,
                image: examData.image,
                background: examData.background,
                logo: examData.logo,
                userID: userID
            )
            try await exam.save(on: database)
            let examID = try exam.requireID()

            for subjectDTO in examData.subjects {
                let subject = Subject(
                    title: subjectDTO.title,
                    image: subjectDTO.image,
                    examID: examID
                )
                try await subject.save(on: database)

                let subjectID = try subject.requireID()

                for questionDTO in subjectDTO.questions {
                    let question = Question(
                        questionNumber: questionDTO.questionNumber,
                        title: questionDTO.title,
                        subjectID: subjectID
                    )

                    try await question.save(on: database)

                    let questionID = try question.requireID()

                    for anwserDTO in questionDTO.answers {
                        let answer = Answer(
                            answerText: anwserDTO.answerText,
                            isCorrect: anwserDTO.isCorrect,
                            questionID: questionID
                        )

                        try await answer.save(on: database)
                    }
                }
            }
            return .ok
        }
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
    let questions: [CreateQuestionData]
}

struct CreateQuestionData: Content {
    let questionNumber: String
    let title: String
    let answers: [CreateAnwserData]
}

struct CreateAnwserData: Content {
    let answerText: String
    let isCorrect: Bool
}
