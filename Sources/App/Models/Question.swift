//
//  Question.swift
//  template-fluent-postgres
//
//  Created by Krzysztof Lema on 11/12/2024.
//

import Vapor
import Fluent

final class Question: Model, @unchecked Sendable {
    static let schema = "questions"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "question_number")
    var questionNumber: String
    
    @Field(key: "title")
    var title: String
    
    @Children(for: \.$question)
    var answers: Array<Answer>
    
    @Parent(key: "subjectID")
    var subject: Subject
    
    init() {}
    
    init(
        id: UUID? = nil,
        questionNumber: String,
        title: String,
        answers: Array<Answer>,
        subjectID: Subject.IDValue
    ) {
        self.id = id
        self.questionNumber = questionNumber
        self.title = title
        self.answers = answers
        self.$subject.id = subjectID
    }
    
    func toDTO() -> QuestionDTO {
        .init(
            id: id,
            title: title,
            questionNumber: questionNumber
        )
    }

}
