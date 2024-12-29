import Fluent
import Vapor

struct ExamController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let examsRoutes = routes.grouped("api", "exams")

        examsRoutes.post(use: createHandler)
        examsRoutes.get("all", use: getAllHandler)
        examsRoutes.get("", use: getExamByIDHandler)
    }

    @Sendable
    func getAllHandler(_ req: Request) async throws -> [Exam] {
        try await Exam
            .query(on: req.db)
            .with(\.$subjects)
            .all()
    }
    
    @Sendable
    func getExamByIDHandler(_ req: Request) async throws -> Exam {
        guard let examIDString = req.query[String.self, at: "examID"],
              let examID = UUID(uuidString: examIDString) else {
            throw Abort(.badRequest, reason: "Invalid or missing examID query parameter")
        }
        guard let exam = try await Exam
            .query(on: req.db)
            .filter(\.$id == examID)
            .with(\.$subjects, { subject in
                subject.with(\.$questions) { question in
                    question.with(\.$answers)
                }
            }).first() else {
             throw Abort(.notFound, reason: "Exam not found")
            }
        return exam
    }

    @Sendable
    func createHandler(_ req: Request) async throws -> HTTPStatus {
        let examData = try req.content.decode(CreateExamData.self)

        return try await req.db.transaction { database in
            let exam = Exam(
                title: examData.title,
                subtitle: examData.subtitle,
                text: examData.text,
                image: examData.image,
                background: examData.background,
                logo: examData.logo
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

                    for answerDTO in questionDTO.answers {
                        let answer = Answer(
                            answerText: answerDTO.answerText,
                            isCorrect: answerDTO.isCorrect,
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

        exam.title = updatedExam.title
        exam.subtitle = updatedExam.subtitle
        exam.text = updatedExam.text
        exam.image = updatedExam.image
        exam.background = updatedExam.logo
        exam.logo = updatedExam.logo

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
    let answers: [CreateAnswerData]
}

struct CreateAnswerData: Content {
    let answerText: String
    let isCorrect: Bool?
}
