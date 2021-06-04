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
        case unknownError(Error)
        case unknown
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

    private static func url(user: String, fromDays: Int) -> URL? {
        guard let fromSecond = Calendar.current.date(byAdding: .day, value: -fromDays, to: Date())?.timeIntervalSince1970 else {
            return nil
        }

        var components = URLComponents()
        components.scheme = "https"
        components.host = "kenkoooo.com"
        components.path = "/atcoder/atcoder-api/v3/user/submissions"
        components.queryItems = [
            .init(name: "user", value: user),
            .init(name: "from_second", value: Int(fromSecond).description)
        ]

        return components.url
    }

    static func fetch(user: String, fromDays: Int = 60) -> AnyPublisher<[Submission], Failure> {
        guard let url = url(user: user, fromDays: fromDays) else {
            return Fail(error: .badRequest).eraseToAnyPublisher()
        }
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw Failure.responseError(URLError(.badServerResponse))
                }
                return element.data
            }
            .decode(type: [Submission].self, decoder: SnakeCaseJSONDecoder())
            .mapError {
                $0 as? Failure ?? .unknownError($0)
            }
            .eraseToAnyPublisher()
    }

    static func fetch(user: String, fromDays: Int = 60, completionHandler: @escaping (Result<[Submission], Failure>) -> Void) {
        guard let url = url(user: user, fromDays: fromDays) else {
            completionHandler(.failure(.badRequest))
            return
        }

        let task = URLSession.shared
            .dataTask(with: url) { data, response, error in
                guard let data = data else {
                    if let error = error {
                        completionHandler(.failure(.unknownError(error)))
                    } else {
                        completionHandler(.failure(.unknown))
                    }
                    return
                }
                do {
                    let submissions = try SnakeCaseJSONDecoder().decode([Submission].self, from: data)
                    completionHandler(.success(submissions))
                } catch {
                    completionHandler(.failure(.unknownError(error)))
                }
            }
        task.resume()
    }
}
