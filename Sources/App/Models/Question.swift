import Fluent
import Vapor

final class Question: Model, @unchecked Sendable {
    static let schema = "questions"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "question_number")
    var questionNumber: String

    @Field(key: "title")
    var title: String

    @Children(for: \.$question)
    var answers: [Answer]

    @Parent(key: "subjectID")
    var subject: Subject

    init() {}

    init(
        id: UUID? = nil,
        questionNumber: String,
        title: String,
        answers: [Answer],
        subjectID: Subject.IDValue
    ) {
        self.id = id
        self.questionNumber = questionNumber
        self.title = title
        self.answers = answers
        $subject.id = subjectID
    }

    func toDTO() -> QuestionDTO {
        .init(
            id: id,
            title: title,
            questionNumber: questionNumber
        )
    }
}
