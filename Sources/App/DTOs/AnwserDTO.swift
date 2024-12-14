import Fluent
import Vapor

struct AnwserDTO: Content {
    
    var id: UUID?
    var answerText: String
    var isCorrect: Bool
    
    func toModel() -> Answer {
        let model = Answer()
        
        model.id = self.id
        model.answerText = self.answerText
        model.isCorrect = self.isCorrect
        
        return model
    }
}
