import Fluent
import Vapor

func routes(_ app: Application) throws {
    let examController = ExamController()
    try app.register(collection: examController)

    let usersController = UsersController()
    try app.register(collection: usersController)
    
    let subjectController = SubjectController()
    try app.register(collection: subjectController)
    
    let questionController = QuestionController()
    try app.register(collection: questionController)
}
