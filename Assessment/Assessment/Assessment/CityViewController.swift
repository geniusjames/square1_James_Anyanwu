//
//  ViewController.swift
//  Assessment
//
//  Created by Geniusjames on 30/07/2022.
//

import UIKit

class CityViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    var listView: UIView!
    var mapView: UIView!
    var viewModel = CityViewModel()
    var cityVC: CityViewController!
    var mapVC: MapViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cityVC = CityListViewController(nibName: "CountryListViewController", bundle: nil)
        cityVC.viewModel = viewModel
        listView = cityVC.view
        containerView.addSubview(listView)
        mapVC = MapViewController(nibName: "MapViewController", bundle: nil)
        mapVC.viewModel = viewModel
        mapView = mapVC.view
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "List View"
        containerView.addSubview(mapView)
        containerView.bringSubviewToFront(listView)
        viewModel.fetchCities(onPage: 1)
        
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            containerView.bringSubviewToFront(listView)
            navigationItem.title = "List View"
        case 1:
            
            containerView.bringSubviewToFront(mapView)
            navigationItem.title =  "Map View"
        default:
            break
        }
    }
}
