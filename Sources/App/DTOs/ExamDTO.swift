import Fluent
import Vapor

struct ExamDTO: Content {
    var id: UUID?
    var title: String
    var subtitle: String
    var text: String
    var image: String
    var background: String
    var logo: String
    
    func toModel() -> Exam {
        let model = Exam()
        
        model.id = self.id
        model.title = self.title
        model.subtitle = self.subtitle
        model.text = self.text
        model.image = self.image
        model.background = self.background
        model.logo = self.logo
        return model
    }
}
