//
//  LocationManager.swift
//  AMCAPISample
//
//  Created by Michael A. Crawford on 9/30/21.
//

import MapKit

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 1, longitude: 1),
                                               span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestAllowOnceLocationPermission() {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.first else { return }
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: lastLocation.coordinate,
                                             span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: Log error.
        print(error.localizedDescription)
    }
}
