import Fluent
import Vapor

struct SubjectDTO: Content {
    var id: UUID?
    var title: String
    var image: String

    func toModel() -> Subject {
        let model = Subject()

        model.id = id
        model.title = title
        model.image = image

        return model
    }
}
