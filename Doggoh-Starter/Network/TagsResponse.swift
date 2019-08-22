//
//  TagsResponse.swift
//  Networking2


import Foundation

struct Language : Codable {
    let en: String
}

struct Tag : Codable {
    let tag : Language
    let confidence: Double
}

struct Tags : Codable {
    let tags: [Tag]
}

struct Status : Codable {
    let text: String
    let type: String
}

struct TagsResponse : Codable {
    let result: Tags
    let status: Status
}
