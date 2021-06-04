import SwiftUI
import Combine

struct ContentView: View {
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
        AtCoderProblemsRepository.fetch(user: "kashihararara")
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let failure):
                    print(failure)
                }
            }, receiveValue: { submissions in
                self.submissions = submissions
            })
            .store(in: &subscriptions)

        SharedUserDefaults.userId = "kashihararara"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
