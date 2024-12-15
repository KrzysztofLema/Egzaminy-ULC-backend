import Fluent
import Vapor

final class Token: Model, Content, @unchecked Sendable {
    static let schema = Schema.title

    @ID(key: .id)
    var id: UUID?

    @Field(key: Key.value)
    var value: String

    @Parent(key: Key.userID)
    var user: User

    init() {}

    init(id: UUID? = nil, value: String, userID: User.IDValue) {
        self.id = id
        self.value = value
        $user.id = userID
    }
}

extension Token {
    static func generate(for user: User) throws -> Token {
        let random = [UInt8].random(count: 16).base64

        return try Token(value: random, userID: user.requireID())
    }
}

extension Token: ModelTokenAuthenticatable {
    static let valueKey = \Token.$value
    static let userKey = \Token.$user

    typealias UserType = App.User

    var isValid: Bool {
        true
    }
}

extension Token {
    enum Key {
        static let value: FieldKey = "value"
        static let userID: FieldKey = "userID"
    }

    enum Schema {
        static let title: String = "tokens"
    }
}
