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

        model.id = id
        model.title = title
        model.subtitle = subtitle
        model.text = text
        model.image = image
        model.background = background
        model.logo = logo
        return model
    }
}
