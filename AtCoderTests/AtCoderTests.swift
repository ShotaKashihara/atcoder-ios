//
//  AtCoderTests.swift
//  AtCoderTests
//
//  Created by Shota Kashihara on 2021/06/02.
//

import XCTest
@testable import AtCoder

class AtCoderTests: XCTestCase {
    func testExample() throws {
        let exp = expectation(description: "fetch and parse")
        let cancellable = AtCoderProblemsRepository.fetch(user: "kashihararara", fromSecond: 1560046356)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { submissions in
                print(submissions)
                exp.fulfill()
            }

        wait(for: [exp], timeout: 10)
    }
}
