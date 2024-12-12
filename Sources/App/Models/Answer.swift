//
//  AnswerDto.swift
//  template-fluent-postgres
//
//  Created by Krzysztof Lema on 11/12/2024.
//

import Vapor
import Fluent

final class Answer: Model, @unchecked Sendable {
    static let schema = "answers"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "anwserText")
    var answerText: String
    
    @Field(key: "isCorrect")
    var isCorrect: Bool
    
    @Parent(key: "questionID")
    var question: Question
    
    init() {}
    
    init(
        id: UUID?,
        answerText: String,
        isCorrect: Bool,
        questionID: Question.IDValue
    ) {
        self.id = id
        self.answerText = answerText
        self.isCorrect = isCorrect
        self.$question.id = questionID
    }
    
    func toDTO() -> AnwserDTO {
        .init(
            id: id,
            answerText: answerText,
            isCorrect: isCorrect
        )
    }

}
