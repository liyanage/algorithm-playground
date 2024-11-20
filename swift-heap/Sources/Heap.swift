//
//  Heap.swift
//  swift-heap
//
//  Created by Marc Liyanage on 11/10/24.
//

import Foundation

protocol IntegerRepresentable {
    var integerRepresentation: Int { get }
}

struct MinHeap<Element: IntegerRepresentable> {

    var content: [Element]
    
    init(content: [Element]) {
        self.content = content
    }
    
    var root: Element? {
        get {
            return content.isEmpty ? nil : content[0]
        }
    }
    
    @inline(__always)
    func parentIndex(_ i: Int) -> Int {
        assert(i < content.count)
        return (i + 1) / 2 - 1
    }
    
    @inline(__always)
    func leftIndex(_ i: Int) -> Int {
        return 2 * (i + 1) - 1
    }

    @inline(__always)
    func rightIndex(_ i: Int) -> Int {
        return 2 * (i + 1)
    }
    
    mutating func minHeapify(_ i: Int) {
        guard !content.isEmpty else {
            return
        }
        let l = leftIndex(i)
        let r = rightIndex(i)
        let count = content.count
        var smallest: Int
        if l.integerRepresentation < count && content[l].integerRepresentation < content[i].integerRepresentation {
            smallest = l
        } else {
            smallest = i
        }
        if r < count && content[r].integerRepresentation < content[smallest].integerRepresentation {
            smallest = r
        }
        if smallest != i {
            content.swapAt(i, smallest)
            minHeapify(smallest)
        }
    }
    
    mutating func buildMinHeap() {
        let lastNonLeafIndex = content.count / 2 - 1
        for i in stride(from: lastNonLeafIndex, through: 0, by: -1) {
            minHeapify(i)
        }
    }
    
    mutating func extractMin() -> Element? {
        guard let min = content.first else {
            return nil
        }
        content[0] = content.last!
        content.removeLast()
        minHeapify(0)
        return min
    }
    
    mutating func decreaseKey(_ i: Int, newValue: Element) {
        assert(i < content.count)
        assert(newValue.integerRepresentation < content[i].integerRepresentation, "New value must be smaller than existing value")
        var currentIndex = i
        content[currentIndex] = newValue
        while currentIndex > 0 && content[parentIndex(currentIndex)].integerRepresentation > content[currentIndex].integerRepresentation {
            let parentIndex = parentIndex(currentIndex)
            content.swapAt(parentIndex, currentIndex)
            currentIndex = parentIndex
        }
    }
    
    mutating func insert(_ newValue: Element) {
        content.append(newValue)
        let i = content.count - 1
        var currentIndex = i
        while currentIndex > 0 && content[parentIndex(currentIndex)].integerRepresentation > content[currentIndex].integerRepresentation {
            let parentIndex = parentIndex(currentIndex)
            content.swapAt(parentIndex, currentIndex)
            currentIndex = parentIndex
        }
    }
    
    func validate() {
        guard content.count > 0 else {
            return
        }
        _validateSubtree(0)
    }
    
    func _validateSubtree(_ parentIndex: Int) {
        let parentValue = content[parentIndex].integerRepresentation
        for (label, childIndex) in [("left", leftIndex(parentIndex)), ("right", rightIndex(parentIndex))] {
            guard childIndex < content.count else {
                continue
            }
            let childValue = content[childIndex].integerRepresentation
            if childValue < parentValue {
                print("\(label) child node \(childIndex) (\(childValue)) unexpectedly smaller than parent \(parentIndex) (\(parentValue))")
            }
            _validateSubtree(childIndex)
        }
    }
    
    func dump() {
        guard content.count > 0 else {
            print("(empty heap)")
            return
        }
        let height = Int(floor(log2(Float(content.count)))) + 1
        let leafLevelMaxNodeCount = Int(pow(2.0, Double(height - 1)))
        let longestValueStringLength = String(content.map { $0.integerRepresentation }.max()!).count
        let leafLevelPaddingWidth = longestValueStringLength + 1

        let combinedMaxDigitsWidth = longestValueStringLength * leafLevelMaxNodeCount
        let combinedMaxPaddingWidth = (leafLevelMaxNodeCount) * leafLevelPaddingWidth
        let leafLevelMaxWidth = combinedMaxDigitsWidth + combinedMaxPaddingWidth

        var index = 0
        for level in 0 ..< height {
            let levelMaxNodeCount = Int(pow(2.0, Double(level)))
            let levelCellWidth = leafLevelMaxWidth / levelMaxNodeCount
            var levelString = ""
            
            for _ in 0 ..< levelMaxNodeCount {
                guard index < content.count else {
                    break
                }
                let valueString = String(content[index].integerRepresentation)
                index += 1
                let paddingLength = levelCellWidth - valueString.count
                let leftPadding = String(repeating: " ", count: paddingLength / 2)
                let rightPadding = String(repeating: " ", count: paddingLength - paddingLength / 2)
                levelString += leftPadding + valueString + rightPadding
            }
            print(levelString)
        }
        
    }
    
    
}


