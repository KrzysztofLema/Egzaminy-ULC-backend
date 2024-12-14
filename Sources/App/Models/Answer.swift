import Fluent
import Vapor

final class Answer: Model, Content, @unchecked Sendable {
    static let schema = "answers"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "anwserText")
    var answerText: String

    @Field(key: "isCorrect")
    var isCorrect: Bool

    @Parent(key: "questionID")
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
