// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import Foundation
import ArgumentParser
import OSLog

actor LineBuffer {
    var unsortedLinesWithNumbers: [(Int, String)] = []
    
    func append(value: (Int, String)) {
        unsortedLinesWithNumbers.append(value)
    }
    
    func sortedLines() -> [String] {
        unsortedLinesWithNumbers.sorted { pairA, pairB in
            return pairA.0 < pairB.0
        }.map { pair in
            pair.1
        }
    }
    
    func sortedPairs() -> [(Int, String)] {
        unsortedLinesWithNumbers.sorted { pairA, pairB in
            return pairA.0 < pairB.0
        }
    }
}


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

struct Converter {
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func process() async throws {
        
        let fileContents = try String(contentsOf: url, encoding: .utf8)
        let lines = splitLines(fileContents)
        print("line count: \(lines.count)")

        let linesWithNumbers = lines.enumerated()

        let signposter = OSSignposter()
        let signpostID = signposter.makeSignpostID()

        var state = signposter.beginInterval("processLines", id: signpostID)

        let buffer = LineBuffer()
        await withThrowingTaskGroup(of: Void.self) { group in
            for lineAndNumber in linesWithNumbers {
                let (lineNumber, line) = lineAndNumber
                group.addTask {
                    await buffer.append(value: (lineNumber, try self.rewriteDoccMarkdownLineForPandoc(line)))
                }
            }
        }

        let unsortedLines = try await withThrowingTaskGroup(of: (Int, String).self) { group in
            for lineAndNumber in linesWithNumbers {
                let (lineNumber, line) = lineAndNumber
                group.addTask {
                    (lineNumber, try self.rewriteDoccMarkdownLineForPandoc(line))
                }
            }
            
            var unsortedProcessedLines: [(Int, String)] = []
            for try await lineNumberAndLine in group {
                unsortedProcessedLines.append(lineNumberAndLine)
            }
            
            return unsortedProcessedLines
        }

        signposter.endInterval("processLines", state)
        print("result line count: \(unsortedLines.count)")

        state = signposter.beginInterval("sortResults", id: signpostID)

        // Variant 1: min heap while reading lines
        // 14ms for 60k items
//        var sortedProcessedLines: [(Int, String)] = []
//        var unsortedProcessedLinesHeap = MinHeap(content: [])
//        for lineNumberAndLine in unsortedLines {
//            unsortedProcessedLinesHeap.insert(lineNumberAndLine)
////            print("heap count \(unsortedProcessedLinesHeap.content.count) min line \(unsortedProcessedLinesHeap.root?.lineNumber) new value \(lineNumberAndLine.0)")
////            unsortedProcessedLinesHeap.validate()
////            unsortedProcessedLinesHeap.dump()
//            while let rootLineNumber = unsortedProcessedLinesHeap.root?.lineNumber, rootLineNumber == sortedProcessedLines.count {
//                let minLine = unsortedProcessedLinesHeap.extractMin()
//                sortedProcessedLines.append(minLine!)   
//            }
//        }

        // Variant 2: just sort everything
        // 3ms for 60k items
        let _: [(Int, String)] = unsortedLines.sorted { $0.0 < $1.0 }
        
//        for pair in sortedProcessedLines {
//            print("\(pair.0) \(pair.1)")
//        }
        
        signposter.endInterval("sortResults", state)
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
