// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import Foundation
import ArgumentParser
import OSLog

@main
struct swiftconcurrency: AsyncParsableCommand {

    @Argument(help: "The input text file 2")
    var path: String

    mutating func run() async throws {
        print("Hello, world \(path)!")
        
        let url = URL(filePath:path)

        let converter = Converter(url: url)
        try await converter.process()
    }

    
}


extension Regex : @unchecked @retroactive Sendable {
}

struct Line: IntegerRepresentable {
    var lineNumber: Int
    var text: String
    
    var integerRepresentation: Int {
        get {
            return self.lineNumber
        }
    }
}

//typealias Line = (lineNumber: Int, text: String)


extension Int: IntegerRepresentable {
    var integerRepresentation: Int {
        get {
            return self
        }
    }
}



struct Converter {
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func process() async throws {
        
        let fileContents = try String(contentsOf: url, encoding: .utf8)
        let lines = splitLines(fileContents)
        print("line count: \(lines.count)")

        let linesWithNumbers = lines.enumerated().map { (lineNumber: Int, text: String) in
            Line(lineNumber: lineNumber, text: text)
        }

        let signposter = OSSignposter()
        let signpostID = signposter.makeSignpostID()

        var state = signposter.beginInterval("processLines", id: signpostID)

        // Option 1, single-threaded, 30ms/3k lines
//        let sorted = try linesWithNumbers.map { lineAndNumber in
//            Line(lineNumber: lineAndNumber.lineNumber, text: try self.rewriteDoccMarkdownLineForPandoc(lineAndNumber.text))
//        }
//        signposter.endInterval("processLines", state)
//        return

        // Option 2, multithreaded, 10ms/3k lines unsorted
        let unsortedLines = try await withThrowingTaskGroup(of: Line.self) { group in
            for lineAndNumber in linesWithNumbers {
                group.addTask {
                    Line(lineNumber: lineAndNumber.lineNumber, text: try self.rewriteDoccMarkdownLineForPandoc(lineAndNumber.text))
                }
            }
            
            var unsortedProcessedLines: [Line] = []
            for try await lineNumberAndLine in group {
                unsortedProcessedLines.append(lineNumberAndLine)
            }
            
            return unsortedProcessedLines
        }

        signposter.endInterval("processLines", state)
        print("result line count: \(unsortedLines.count)")

        state = signposter.beginInterval("sortResults", id: signpostID)
        let duration = ContinuousClock().measure {
            

            // Variant 1: min heap while reading lines
            // 14ms for 60k items
//            var sortedProcessedLines: [Line] = []
//            var unsortedProcessedLinesHeap = MinHeap(content: [Line]())
//            for lineNumberAndLine in unsortedLines {
//                unsortedProcessedLinesHeap.insert(lineNumberAndLine)
////                print("heap count \(unsortedProcessedLinesHeap.content.count) min line \(unsortedProcessedLinesHeap.root?.lineNumber) new value \(lineNumberAndLine.lineNumber)")
////                unsortedProcessedLinesHeap.validate()
////                unsortedProcessedLinesHeap.dump()
//                while let rootLineNumber = unsortedProcessedLinesHeap.root?.lineNumber, rootLineNumber == sortedProcessedLines.count {
//                    let minLine = unsortedProcessedLinesHeap.extractMin()
//                    sortedProcessedLines.append(minLine!)
//                }
//            }

            // Variant 2: just sort everything
            // 3ms for 60k items
            let sortedProcessedLines: [Line] = unsortedLines.sorted { $0.lineNumber < $1.lineNumber }

//            for line in sortedProcessedLines {
//                print("\(line.lineNumber) \(line.text)")
//            }
            
            // Variant 3: insert into sorted array
            // 0.3ms for 3k items (
//            var sorted: [Line?] = Array(repeating: nil, count: unsortedLines.count)
//            for lineNumberAndLine in unsortedLines {
//                sorted[lineNumberAndLine.lineNumber] = lineNumberAndLine
//            }

        }

        signposter.endInterval("sortResults", state)
        
        print("duration: \(duration)")
    }
    
    func splitLines(_ text: String) -> [String] {
        var items = [String]()
        // We use this instead of split(whereSeparator:) or components(separatedBy:)
        // because we need to match the behavior of Python's splitlines()
        text.enumerateLines { line, stop in items.append(line) }
        return items
    }

    
    func rewriteDoccMarkdownLineForPandoc(_ line: String) throws -> String {
//        var line = rewriteDoccMarkdownLineForPandocInternalReferences(line, urlsAndTitlesMapping: urlsAndTitlesMapping)
        var line = rewriteDoccMarkdownLineForPandocOptionalityMarker(line)
//        line = try rewriteDoccMarkdownLineForPandocImageReference(line, bookURL: bookURL)
        line = rewriteDoccMarkdownLineForPandocHeadingLevelShift(line)
        return line
    }

    private let optionalityMarkerRegex = /(\*{1,2})_\?_/
    func rewriteDoccMarkdownLineForPandocOptionalityMarker(_ line: String) -> String {
        // This fixes the markup used for ? optionality
        // markers used in grammar blocks
        return line.replacing(optionalityMarkerRegex) { match in
            return "?\(match.1)"
        }
    }
    
    private let headingRegex = /^(#+ .+)/
    func rewriteDoccMarkdownLineForPandocHeadingLevelShift(_ line: String) -> String {
        if let match = line.firstMatch(of: headingRegex) {
            // We need to shift down the heading levels for each included
            // per-chapter markdown file by one level so they line up with
            // the headings in the main file.
            return "#\(match.1)"
        }
        return line
    }




}
