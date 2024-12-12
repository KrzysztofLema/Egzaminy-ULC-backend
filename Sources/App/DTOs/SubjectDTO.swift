import Fluent
import Vapor

struct SubjectDTO: Content {
    var id: UUID?
    var title: String
    var image: String
    
    func toModel() -> Subject {
        let model = Subject()
        
        model.id = self.id
        model.title = self.title
        model.image = self.image
        
        return model
    }
}
