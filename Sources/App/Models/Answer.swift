import Fluent
import Vapor

final class Answer: Model, Content, @unchecked Sendable {
    static let schema = Schema.title

    @ID(key: .id)
    var id: UUID?

    @Field(key: Key.answerText)
    var answerText: String

    @Field(key: Key.isCorrect)
    var isCorrect: Bool

    @Parent(key: Key.questionID)
    var question: Question

    init() {}

    init(
        id: UUID? = nil,
        answerText: String,
        isCorrect: Bool,
        questionID: Question.IDValue
    ) {
        self.id = id
        self.answerText = answerText
        self.isCorrect = isCorrect
        $question.id = questionID
    }
}

extension Answer {
    enum Key {
        static let answerText: FieldKey = "answerText"
        static let isCorrect: FieldKey = "isCorrect"
        static let questionID: FieldKey = "questionID"
    }

    enum Schema {
        static let title: String = "answer"
    }
}
