//
//  Paginator.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/9/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

/// Manages a paginated result set from a database query. Repeats the query with different
///
/// The user provides `recordsPerPage` which corresponds to the SQL LIMIT argument, and a `retrieve`
/// closure that takes `startIndex` and `maxRecords` arguments that correspond to SQL OFFSET and LIMIT,
/// and promises to optionally return the total count of records retrievable from the query and a "page"
/// of records no larger than the `maxRecords` argument.
public class Paginator<T> {
  public typealias Record = T
  public typealias Page = [Record]
  public typealias RetrieveResult = (countOfRecords: Int?, page: Page)
  public typealias RetrieveBlock = (_ startIndex: Int, _ maxRecords: Int) -> Promise<RetrieveResult>
  
  private var pages = [Int : Page]()
  private var pagePromises = [Int: [Promise<Page>]]()
  private var recordPromises = [Int: [(recordPromise: Promise<Record>, itemIndex: Int)]]()
  
  public let recordsPerPage: Int
  public let retrieve: RetrieveBlock
  public private(set) var countOfRecords: Int?
  
  public init(recordsPerPage: Int, retrieve: @escaping RetrieveBlock) {
    self.recordsPerPage = recordsPerPage
    self.retrieve = retrieve
  }
  
  public var countOfPages: Int? {
    guard let countOfRecords = countOfRecords else { return nil }
    let fullPages = countOfRecords / recordsPerPage
    let recordsOnPartialPage = countOfRecords - (recordsPerPage * fullPages)
    return fullPages + (recordsOnPartialPage > 0 ? 1 : 0)
  }
  
  public func retrievePage(at pageIndex: Int = 0) -> Promise<Page> {
    let startIndex = pageIndex * recordsPerPage
    let maxRecords = recordsPerPage
    return Promise<Page> { pagePromise in
      if let page = self.pages[pageIndex] {
        pagePromise.keep(page)
      } else {
        if self.pagePromises[pageIndex] != nil {
          self.pagePromises[pageIndex]!.append(pagePromise)
        } else {
          let pagePromise = self.retrieve(startIndex, maxRecords).map(to: pagePromise) { (pagePromise, result: RetrieveResult) in
            if let newCountOfRecords = result.countOfRecords, self.countOfRecords == nil {
              self.countOfRecords = newCountOfRecords
            }
            let page = result.page
            self.pages[pageIndex] = page
            for pagePromise in self.pagePromises[pageIndex]! {
              pagePromise.keep(page)
            }
            self.pagePromises[pageIndex] = nil
          }
          self.pagePromises[pageIndex] = [pagePromise]
        }
      }
    }
  }
  
  public func retrieveRecord(at recordIndex: Int) -> Promise<Record> {
    let pageIndex = recordIndex / recordsPerPage
    let itemIndex = recordIndex % recordsPerPage
    return Promise<Record> { recordPromise in
      if let page = self.pages[pageIndex] {
        let record = page[itemIndex]
        recordPromise.keep(record)
      } else {
        if self.recordPromises[pageIndex] != nil {
          self.recordPromises[pageIndex]!.append((recordPromise: recordPromise, itemIndex: itemIndex))
        } else {
          let recordPromise = self.retrievePage(at: pageIndex).map(to: recordPromise) { (recordPromise, page) in
            self.pages[pageIndex] = page
            for i in self.recordPromises[pageIndex]! {
              let record = page[i.itemIndex]
              i.recordPromise.keep(record)
            }
            self.recordPromises[pageIndex] = nil
          }
          self.recordPromises[pageIndex] = [(recordPromise: recordPromise, itemIndex: itemIndex)]
        }
      }
    }
  }
}

//
// Prints:
//
//    countOfRecords: 100 retrieved records: ["[0: 0] at", "[0: 1] ut", "[0: 2] suscipit", "[0: 3] sapiente", "[0: 4] nobis", "[0: 5] esse", "[0: 6] inventore", "[0: 7] laboriosam", "[0: 8] veniam", "[0: 9] non"]
//    [0: 5] esse
//    [0: 5] esse
//    countOfRecords: 100 retrieved records: ["[50: 0] qui", "[50: 1] voluptatem", "[50: 2] cupiditate", "[50: 3] cumque", "[50: 4] voluptas", "[50: 5] explicabo", "[50: 6] praesentium", "[50: 7] quasi", "[50: 8] et", "[50: 9] quae"]
//    [50: 5] explicabo
//

#if false
  
  public class PaginatorTest {
    let retriever: Retriever
    let paginator: Paginator<String>
    
    class Retriever {
      typealias RetrieveResult = (countOfRecords: Int?, page: [String])
      
      let countOfRecords: Int?
      
      init(countOfRecords: Int?) {
        self.countOfRecords = countOfRecords
      }
      
      func retrieve(startIndex: Int, maxRecords: Int) -> Promise<RetrieveResult> {
        return Promise<RetrieveResult> { promise in
          dispatchOnBackground {
            dispatchOnMain(afterDelay: 0.5) {
              let records = (0..<maxRecords).map {
                return "[\(startIndex): \($0)] \(Lorem.word())"
              }
              print("countOfRecords: \(self.countOfRecords†) retrieved records: \(records)")
              promise.keep((countOfRecords: self.countOfRecords, page: records))
            }
          }
        }
      }
    }
    
    public init() {
      retriever = Retriever(countOfRecords: 100)
      paginator = Paginator(recordsPerPage: 10, retrieve: retriever.retrieve)
    }
    
    static private var test: PaginatorTest!
    
    public static func run() {
      test = PaginatorTest()
      test.run()
    }
    
    private func run() {
      dispatchOnMain(afterDelay: 4) {
        self.paginator.retrieveRecord(at: 5).then { record in
          print(record)
          }.run()
      }
      
      dispatchOnMain(afterDelay: 4) {
        self.paginator.retrieveRecord(at: 5).then { record in
          print(record)
          }.run()
      }
      
      dispatchOnMain(afterDelay: 5) {
        self.paginator.retrieveRecord(at: 55).then { record in
          print(record)
          }.run()
      }
    }
  }
#endif
