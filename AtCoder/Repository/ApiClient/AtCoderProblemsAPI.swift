import Foundation
import Combine

struct Submission: Decodable, Identifiable {
    let id: Int
    let epochSecond: Int
    let problemId: String
    let contestId: String
    let userId: String
    let language: String
    let point: Int
    let length: Int
    let result: String
    let executionTime: Int?
}

enum AtCoderProblemsRepository {
    enum Failure: Error {
        case badRequest
        case responseError(URLError)
        case unknown(Error)
    }

    struct Endpoint {
        let path: String
        let queryItems: [URLQueryItem]
        var url: URL? {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "kenkoooo.com"
            components.path = path
            components.queryItems = queryItems
            return components.url
        }
    }

    static func fetch(user: String, fromSecond: Int) -> AnyPublisher<[Submission], Failure> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "kenkoooo.com"
        components.path = "/atcoder/atcoder-api/v3/user/submissions"
        components.queryItems = [
            .init(name: "user", value: user),
            .init(name: "from_second", value: fromSecond.description)
        ]

        guard let url = components.url else {
            return Fail(error: .badRequest).eraseToAnyPublisher()
        }

        print(url.absoluteString)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw Failure.responseError(URLError(.badServerResponse))
                }
                return element.data
            }
            .decode(type: [Submission].self, decoder: decoder)
            .mapError {
                $0 as? Failure ?? .unknown($0)
            }
            .eraseToAnyPublisher()
    }
}
