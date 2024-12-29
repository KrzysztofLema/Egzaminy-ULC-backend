import Fluent
import Foundation

struct CreateExam: AsyncMigration {
    private typealias ExamKey = Exam.Key
    private typealias Schema = Exam.Schema
    private typealias UsersSchema = User.Schema
    
    func prepare(on database: any Database) async throws {
        try await database.schema(Schema.title)
            .id()
            .field(ExamKey.title, .string, .required)
            .field(ExamKey.subtitle, .string, .required)
            .field(ExamKey.text, .string, .required)
            .field(ExamKey.image, .string, .required)
            .field(ExamKey.background, .string, .required)
            .field(ExamKey.logo, .string, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(Schema.title).delete()
    }
}

struct SeedExam: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        let fileManager = FileManager.default
        let path = fileManager.currentDirectoryPath + "/Public/exams.json"
        if let data = fileManager.contents(atPath: path) {
            let examData = try JSONDecoder().decode([CreateExamData].self, from: data)
            
            for exam in examData {
                
                let examDTO = Exam(
                    title: exam.title,
                    subtitle: exam.subtitle,
                    text: exam.text,
                    image: exam.image,
                    background: exam.background,
                    logo: exam.logo
                    //                userID: userID
                )
                try await examDTO.save(on: database)
                let examID = try examDTO.requireID()
                
                for subjectDTO in exam.subjects {
                    let subject = Subject(
                        title: subjectDTO.title,
                        image: subjectDTO.image,
                        examID: examID
                    )
                    try await subject.save(on: database)
                    
                    let subjectID = try subject.requireID()
                    
                    for questionDTO in subjectDTO.questions {
                        let question = Question(
                            questionNumber: questionDTO.questionNumber,
                            title: questionDTO.title,
                            subjectID: subjectID
                        )
                        
                        try await question.save(on: database)
                        
                        let questionID = try question.requireID()
                        
                        for answerDTO in questionDTO.answers {
                            let answer = Answer(
                                answerText: answerDTO.answerText,
                                isCorrect: answerDTO.isCorrect,
                                questionID: questionID
                            )
                            
                            try await answer.save(on: database)
                        }
                    }
                }
            }
            
        } else {
            fatalError("company.json not found. Set scheme's `Working Directory` to the project's folder and try again.")
        }
    }
    
    func revert(on database: Database) async throws {
        try await database
            .schema(Exam.schema)
            .delete()
    }
}
