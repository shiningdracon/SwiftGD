import XCTest
@testable import SwiftGD

class SwiftGDTests: XCTestCase {
    func testCreateEmptyImage() {
        //given
        let width = 500
        let height = 500
        
        //when
        let sut = Image(width: width, height: height)
    
        //then
        let size = sut?.size
        
        XCTAssertNotNil(sut)
        XCTAssertEqual(size?.width, width)
        XCTAssertEqual(size?.height, height)
    }


    static var allTests : [(String, (SwiftGDTests) -> () throws -> Void)] {
        return [
            ("testCreateEmptyImage", testCreateEmptyImage),
        ]
    }
}
