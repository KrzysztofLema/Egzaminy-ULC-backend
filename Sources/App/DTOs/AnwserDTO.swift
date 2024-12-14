import Fluent
import Vapor

struct AnwserDTO: Content {
    var id: UUID?
    var answerText: String
    var isCorrect: Bool

    func toModel() -> Answer {
        let model = Answer()

        model.id = id
        model.answerText = answerText
        model.isCorrect = isCorrect

        return model
    }
}
