import Fluent
import Vapor

func routes(_ app: Application) throws {
    let examController = ExamController()
    try app.register(collection: examController)
}
