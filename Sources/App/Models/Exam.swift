import Fluent
import Vapor

final class Exam: Model, Content, @unchecked Sendable {
    static let schema = Schema.title

    @ID(key: .id)
    var id: UUID?

    @Field(key: Key.title)
    var title: String

    @Field(key: Key.subtitle)
    var subtitle: String

    @Field(key: Key.text)
    var text: String

    @Field(key: Key.image)
    var image: String

    @Field(key: Key.background)
    var background: String

    @Field(key: Key.logo)
    var logo: String

    @Children(for: \.$exam)
    var subjects: [Subject]

    init() {}

    init(
        id: UUID? = nil,
        title: String,
        subtitle: String,
        text: String,
        image: String,
        background: String,
        logo: String
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.text = text
        self.image = image
        self.background = background
        self.logo = logo
    }
}

extension Exam {
    enum Key {
        static let title: FieldKey = "title"
        static let subtitle: FieldKey = "subtitle"
        static let text: FieldKey = "text"
        static let image: FieldKey = "image"
        static let background: FieldKey = "background"
        static let logo: FieldKey = "logo"
    }

    enum Schema {
        static let title: String = "exams"
    }
}
