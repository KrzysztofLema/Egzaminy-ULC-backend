import Fluent
import Vapor

struct QuestionDTO: Content {
    
    var id: UUID?
    var title: String?
    var questionNumber: String
    
    func toModel() -> Question {
        let model = Question()
        
        model.id = self.id
        model.questionNumber = self.questionNumber
        
        return model
    }
}
