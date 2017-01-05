import XCTest
@testable import SwiftGD
import Foundation

struct TestHelper {
    static let pngBase64 = "iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFAQAAAAClFBtIAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QAAd2KE6QAAAALSURBVAjXY2CAAQAACgAB5/ja+gAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxNy0wMS0wNFQxNjo1NTozOSswMTowMBVM0agAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTctMDEtMDRUMTY6NTU6MzkrMDE6MDBkEWkUAAAAAElFTkSuQmCC"
    
    static let jpgBase64 = "/9j/4AAQSkZJRgABAQAASABIAAD/4QBMRXhpZgAATU0AKgAAAAgAAgESAAMAAAABAAEAAIdpAAQAAAABAAAAJgAAAAAAAqACAAQAAAABAAAABaADAAQAAAABAAAABQAAAAD/7QA4UGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAAA4QklNBCUAAAAAABDUHYzZjwCyBOmACZjs+EJ+/+IBiElDQ19QUk9GSUxFAAEBAAABeGFwcGwCEAAAbW50ckdSQVlYWVogB9UABwABAAAAAAAAYWNzcEFQUEwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPbWAAEAAAAA0y1hcHBsAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEZGVzYwAAALQAAAB1Y3BydAAAASwAAAAnd3RwdAAAAVQAAAAUa1RSQwAAAWgAAAAOZGVzYwAAAAAAAAAbQ2FsaWJyYXRlZCBHcmF5IENvbG9yc3BhY2UAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdGV4dAAAAABDb3B5cmlnaHQgQXBwbGUgQ29tcHV0ZXIsIEluYy4AAFhZWiAAAAAAAADzUQABAAAAARbMY3VydgAAAAAAAAABAjMAAP/AAAsIAAUABQEBEQD/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/2wBDAAICAgICAgMCAgMEAwMDBAUEBAQEBQcFBQUFBQcIBwcHBwcHCAgICAgICAgKCgoKCgoLCwsLCw0NDQ0NDQ0NDQ3/3QAEAAH/2gAIAQEAAD8A/n/r/9k="
    
    static func writePNG() -> URL? {
        return writeImage(base64: pngBase64, name: "image.png")
    }
    
    static func writeJPG() -> URL? {
        return writeImage(base64: jpgBase64, name: "image.jpg")
    }
    
    static func writeImage(base64:String, name:String) -> URL? {
        let data = Data(base64Encoded: base64)
        var url = URL(fileURLWithPath: NSTemporaryDirectory())
        url.appendPathComponent(name)
        do {
            try data?.write(to: url)
        } catch let error {
            print("\(error)")
            return nil
        }
        return url
    }
    
}

class SwiftGDTests: XCTestCase {
    
    
    func testCreateEmptyImage() {
        //given
        let width = 500
        let height = 500
        
        //when
        let sut = Image(width: width, height: height)
    
        //then
        XCTAssertNotNil(sut)
        
        let size = sut?.size
        XCTAssertEqual(size?.width, width)
        XCTAssertEqual(size?.height, height)
    }
    
    func testReadingPNGFromFile() {
        //given
        guard let imageURL = TestHelper.writePNG() else {
            XCTFail("can't save test image")
            return
        }
//        print("using \(imageURL.path) as test image")
        
        //when
        let sut = Image(url: imageURL)
        
        //then
        XCTAssertNotNil(sut)
        
        let size = sut?.size
        XCTAssertEqual(size?.width, 5)
        XCTAssertEqual(size?.height, 5)
    }
    
    func testReadingJPGFromFile() {
        //given
        guard let imageURL = TestHelper.writeJPG() else {
            XCTFail("can't save test image")
            return
        }
//        print("using \(imageURL.path) as test image")
        
        //when
        let sut = Image(url: imageURL)
        
        //then
        XCTAssertNotNil(sut)
        
        let size = sut?.size
        XCTAssertEqual(size?.width, 5)
        XCTAssertEqual(size?.height, 5)
    }
    
    func testFailToReadPNGfromJPGFile() {
        //given
        guard let imageURL = TestHelper.writeImage(base64:TestHelper.jpgBase64, name:"bad.png") else {
            XCTFail("can't save test image")
            return
        }
//        print("using \(imageURL.path) as test image")
        
        //when
        let sut = Image(url: imageURL)
        
        //then
        XCTAssertNil(sut)
    }

    
    func testCreateImageFromJPGData() {
        //given
        guard var data = Data(base64Encoded: TestHelper.jpgBase64) else {
            XCTFail("can't generate test image")
            return
        }
        
        //when
        let sut = Image(data:&data)
        
        //then
        XCTAssertNotNil(sut)
        
        let size = sut?.size
        XCTAssertEqual(size?.width, 5)
        XCTAssertEqual(size?.height, 5)
        
    }

    func testCreateImageFromPNGData() {
        //given
        guard var data = Data(base64Encoded: TestHelper.pngBase64) else {
            XCTFail("can't generate test image")
            return
        }
        
        //when
        let sut = Image(data:&data)
        
        //then
        XCTAssertNotNil(sut)
        
        let size = sut?.size
        XCTAssertEqual(size?.width, 5)
        XCTAssertEqual(size?.height, 5)
    }

    func testCreateImageFromJPGBytes() {
        //given
        guard let data = Data(base64Encoded: TestHelper.jpgBase64) else {
            XCTFail("can't generate test image")
            return
        }
        var bytes:[UInt8] = [UInt8](data)
        
        //when
        let sut = Image(bytes:&bytes)
        
        //then
        XCTAssertNotNil(sut)
        
        let size = sut?.size
        XCTAssertEqual(size?.width, 5)
        XCTAssertEqual(size?.height, 5)
    }
    
    func testCreateImageFromPNGBytes() {
        //given
        guard let data = Data(base64Encoded: TestHelper.pngBase64) else {
            XCTFail("can't generate test image")
            return
        }
        var bytes:[UInt8] = [UInt8](data)
        
        //when
        let sut = Image(bytes:&bytes)
        
        //then
        XCTAssertNotNil(sut)
        
        let size = sut?.size
        XCTAssertEqual(size?.width, 5)
        XCTAssertEqual(size?.height, 5)
    }
    
    func testTryCreatingImageFromHTMLFile() {
        //given
        guard let data = "<html></html>".data(using: .utf8) else {
            XCTFail("can't generate test image")
            return
        }
        var bytes:[UInt8] = [UInt8](data)
        
        //when
        let sut = Image(bytes:&bytes)
        
        //then
        XCTAssertNil(sut)
    }
    
    func testMorph() throws {
        //given
        let a = 1000
        let sut = Image(width:a, height:a)!
        
        //when
        sut.morph{ x, y, color in
            return Color(red: Double(y)/Double(a), green:Double(y)/Double(a), blue: Double(x)/Double(a), alpha: 1)
        }
        
        var url = URL(fileURLWithPath: NSTemporaryDirectory())
        url.appendPathComponent("morph.jpg")
        
        let fm = FileManager()
        
        if fm.fileExists(atPath: url.path) {
            try fm.removeItem(at: url)
        }
        
        guard sut.write(to: url) else {
            XCTFail("can't save image")
            return
        }
        
        print("image saved to \(url.path)")
        
        //then
        XCTAssertNotNil(sut)
        
        let size = sut.size
        XCTAssertEqual(size.width, a)
        XCTAssertEqual(size.height, a)
    }

    static var allTests : [(String, (SwiftGDTests) -> () throws -> Void)] {
        return [
            ("testCreateEmptyImage", testCreateEmptyImage),
            ("testReadingPNGFromFile", testReadingPNGFromFile),
            ("testReadingJPGFromFile", testReadingJPGFromFile),
            ("testFailToReadPNGfromJPGFile", testFailToReadPNGfromJPGFile),
            ("testCreateImageFromJPGData", testCreateImageFromJPGData),
            ("testCreateImageFromPNGData", testCreateImageFromPNGData),
            ("testCreateImageFromJPGBytes", testCreateImageFromJPGBytes),
            ("testCreateImageFromPNGBytes", testCreateImageFromPNGBytes),
            ("testTryCreatingImageFromHTMLFile", testTryCreatingImageFromHTMLFile),
            ("testMorph", testMorph)
        ]
    }
}
