import Fluent
import Vapor

final class Subject: Model, Content, @unchecked Sendable {
    static let schema = Schema.title

    @ID(key: .id)
    var id: UUID?

    @Field(key: Key.title)
    var title: String

    @Field(key: Key.image)
    var image: String

    @Parent(key: Key.examID)
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

extension Subject {
    enum Key {
        static let title: FieldKey = "title"
        static let image: FieldKey = "image"
        static let examID: FieldKey = "examID"
    }

    enum Schema {
        static let title: String = "subjects"
    }
}
