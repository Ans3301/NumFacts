// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct Fact: Codable, Sendable {
    public let text: String
    public let number: Int64
}

public enum ValidationError: Error {
    case insufficientInput
    case incorrectRangeInput

    public var errorMessage: String {
        switch self {
        case .insufficientInput:
            return "Invalid input data. There must be more than one number."
        case .incorrectRangeInput:
            return "Invalid input data. The first number must be less than the second."
        }
    }
}

public struct NumFacts: Sendable {
    public init() {}

    public func factAboutNumber(number: Int64) async throws -> Fact {
        let baseURL = "http://numbersapi.com"
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw URLError(.badURL)
        }

        urlComponents.path = "/\(number)"

        urlComponents.queryItems = [
            URLQueryItem(name: "json", value: nil)
        ]

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoded = try JSONDecoder().decode(Fact.self, from: data)

        return decoded
    }

    public func factAboutRandomNumber() async throws -> Fact {
        let baseURL = "http://numbersapi.com"
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw URLError(.badURL)
        }

        urlComponents.path = "/random"

        urlComponents.queryItems = [
            URLQueryItem(name: "json", value: nil)
        ]

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoded = try JSONDecoder().decode(Fact.self, from: data)

        return decoded
    }

    public func factAboutRandomNumberInRange(min: Int64, max: Int64) async throws -> Fact {
        if min > max {
            throw ValidationError.incorrectRangeInput
        }

        let baseURL = "http://numbersapi.com"
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw URLError(.badURL)
        }

        urlComponents.path = "/random"

        urlComponents.queryItems = [
            URLQueryItem(name: "json", value: nil),
            URLQueryItem(name: "min", value: String(min)),
            URLQueryItem(name: "max", value: String(max))
        ]

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoded = try JSONDecoder().decode(Fact.self, from: data)

        return decoded
    }

    public func factsAboutMultipleNumbers(numbers: [Int64]) async throws -> [Fact] {
        if numbers.count <= 1 {
            throw ValidationError.insufficientInput
        }

        let string = numbers.map { String($0) }.joined(separator: ",")
        let urlString = "http://numbersapi.com/\(string)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, _) = try await URLSession.shared.data(for: request)

        let decoded = try JSONDecoder().decode([String: Fact].self, from: data)

        var facts: [Fact] = []
        for fact in decoded.values {
            facts.append(fact)
        }

        return facts
    }
}
