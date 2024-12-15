import Fluent
import Vapor

final class Question: Model, Content, @unchecked Sendable {
    static let schema = Schema.title

    @ID(key: .id)
    var id: UUID?

    @Field(key: Key.questionNumber)
    var questionNumber: String

    @Field(key: Key.title)
    var title: String

    @Children(for: \.$question)
    var answers: [Answer]

    @Parent(key: Key.subjectID)
    var subject: Subject

    init() {}

    init(
        id: UUID? = nil,
        questionNumber: String,
        title: String,
        subjectID: Subject.IDValue
    ) {
        self.id = id
        self.questionNumber = questionNumber
        self.title = title
        $subject.id = subjectID
    }
}

extension Question {
    enum Key {
        static let questionNumber: FieldKey = "question_number"
        static let title: FieldKey = "title"
        static let subjectID: FieldKey = "subjectID"
    }

    enum Schema {
        static let title: String = "questions"
    }
}
