//
//  PlacePicker_iOSTests.swift
//  PlacePicker-iOSTests
//
//  Created by Piotr Bernad on 04/07/2019.
//  Copyright © 2019 Piotr Bernad. All rights reserved.
//

import CoreLocation
import GooglePlaces
import GoogleMaps
import XCTest
@testable import PlacePicker

class PlacePicker_iOSTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
class TestError: Error {}

struct GMSGeocoder_Mock: GeocoderProtocol {
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completionHandler: @escaping (ReverseGeocodeResponse?, Error?) -> ()) {
        switch coordinate {
        case .Prague:
            let response = ReverseGeocodeResponse(results: [ReverseGeocodeResult(formattedAddress: "Some address", placeId: "Some id"), ReverseGeocodeResult(formattedAddress: "Some other address", placeId: "Some id")])
            return completionHandler(response, nil)
        case .Bratislava:
            return completionHandler(ReverseGeocodeResponse(results: []), nil)
        default:
            return completionHandler(nil, TestError())
        }
    }
}

struct PlacesListRenderer_Mock: PlacesListRenderer {
    func registerCells(tableView: UITableView) {
        tableView.register(TestCell.self, forCellReuseIdentifier: "test")
    }
    
    func cellForRowAt(indexPath: IndexPath, tableView: UITableView, object: PlacesListObjectType) -> UITableViewCell {
        let cell = TestCell()
        cell.state = object
        return cell
    }
}

class PlacesDataSourceDelegate_Mock: PlacesDataSourceDelegate {
    var flag: Bool = false
    
    func placePickerDidSelectPlace(place: GMSPlace) {
        flag = true
    }
    
    func autoCompleteControllerDidProvide(place: GMSPlace) {}
}
extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}

extension CLLocationCoordinate2D {
    static var Prague: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 50.08804, longitude: 14.42076)
    }
    
    static var Bratislava: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 48.14816, longitude: 17.10674)
    }
}

class TestCell: UITableViewCell {
    var state: PlacesListObjectType!
}
}
