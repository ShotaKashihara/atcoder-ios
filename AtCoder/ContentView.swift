import SwiftUI
import Combine

struct ContentView: View {
    let submissions = [Submission.init(id: 1, epochSecond: 1, problemId: "", contestId: "", userId: "", language: "", point: 1, length: 1, result: "", executionTime: 1)]

    @ObservedObject
    var reactor = Reactor()

    var body: some View {
        ScrollView {
            LazyVStack(content: {
                ForEach(reactor.submissions) { submission in
                    Text(submission.id.description)
                }
            })
        }
    }
}

class Reactor: ObservableObject {

    @Published
    var submissions: [Submission] = []

    var subscriptions = Set<AnyCancellable>()

    init() {
        AtCoderProblemsRepository.fetch(user: "kashihararara", fromSecond: 1560046356)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { submissions in
                self.submissions = submissions
            })
            .store(in: &subscriptions)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


