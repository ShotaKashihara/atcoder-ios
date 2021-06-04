import Foundation

class SnakeCaseJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        self.keyDecodingStrategy = .convertFromSnakeCase
    }
}
