import Fluent
import Vapor

final class Subject: Model, Content, @unchecked Sendable {
    static let schema = "subjects"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "image")
    var image: String

    @Parent(key: "examID")
    var exam: Exam

    @Children(for: \.$subject)
    var questions: [Question]

    init() {}

    init(
        id: UUID? = nil,
        title: String,
        image: String,
        examID: Exam.IDValue
    ) {
        self.id = id
        self.title = title
        self.image = image
        $exam.id = examID
    }
}
