//
//  MapViewController.swift
//  Assessment
//
//  Created by Geniusjames on 31/07/2022.
//

import UIKit
import MapKit
import Combine

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var viewModel: CityViewModel!
    private var cancellables: Set<AnyCancellable> = []

     override func viewDidLoad() {
        super.viewDidLoad()
         
        setupObservers()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.title = "MapView"
    }
    func setupObservers() {
        viewModel.$cities
            .receive(on: RunLoop.main)
            .sink(receiveValue: { value in
                self.updateMap()
            })
            .store(in: &cancellables)
    }
    
    func updateMap() {
        var isFirst = true
        viewModel.cities.forEach {
            if let lat = $0.lat, let lng = $0.lng {
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                let pin = MKPointAnnotation()
                pin.coordinate = coordinate
                mapView.addAnnotation(pin)
                if isFirst {
                    let zoomOut = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                    mapView.setRegion(mapView.regionThatFits(zoomOut), animated: true)
                }
                isFirst = false
            }
            
        }
    }
}
