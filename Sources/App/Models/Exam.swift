import Fluent
import Vapor

final class Exam: Model, Content, @unchecked Sendable {
    static let schema = "exams"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "subtitle")
    var subtitle: String

    @Field(key: "text")
    var text: String

    @Field(key: "image")
    var image: String

    @Field(key: "background")
    var background: String

    @Field(key: "logo")
    var logo: String

    @Children(for: \.$exam)
    var subjects: [Subject]

    @Parent(key: "userID")
    var user: User

    init() {}

    init(
        id: UUID? = nil,
        title: String,
        subtitle: String,
        text: String,
        image: String,
        background: String,
        logo: String,
        userID: User.IDValue
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.text = text
        self.image = image
        self.background = background
        self.logo = logo
        $user.id = userID
    }
}
