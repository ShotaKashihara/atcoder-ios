struct Array2D<Element> {
    let x: Int
    let y: Int
    private var elements: [Element]

    init(repeating: Element, _ x: Int, _ y: Int) {
        self.x = x
        self.y = y
        self.elements = [Element](repeating: repeating, count: x * y)
    }

    subscript(x: Int, y: Int) -> Element {
        get {
            elements[x + y * self.x]
        }
        set {
            elements[x + y * self.x] = newValue
        }
    }
}

extension Optional: CustomStringConvertible where Wrapped: CustomStringConvertible {
    public var description: String {
        self?.description ?? "nil"
    }
}

extension Array2D: CustomStringConvertible where Element: CustomStringConvertible {
    private var padding: Int { elements.map(\.description.count).max() ?? 0 }
    private var paddingStr: String { Array(repeating: " ", count: padding).joined() }
    var description: String {
        var text = "x: \(x), y: \(y)"
        for i in 0..<y {
            text += "\n"
            text += elements[i * x ..< i * x + x]
                .map { (paddingStr + $0.description).suffix(padding) }
                .joined(separator: " ")
        }
        return text
    }
}
