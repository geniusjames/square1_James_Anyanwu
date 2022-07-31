//
//  CityViewModel.swift
//  Assessment
//
//  Created by Geniusjames on 31/07/2022.
//

import Foundation
import Combine

final class CityViewModel {
   @Published var cities: [City] = []
    @Published var errorText: String?
    var total = 0
    var currentPage = 0
    var isLoading = false
    func fetchCities(onPage page: Int) {
        APIService.shared.getCities(page: page) { result in
            switch result {
                
            case .success(let response):
                self.cities = response.data.items
                self.total = response.data.pagination.total
                self.currentPage = response.data.pagination.currentPage
                self.isLoading = false
                print(response)
            case .failure(let error):
                self.errorText = error.localizedDescription
            }
            
        }
    }
    
    func searchCities(name: String, page: Int = 1) {
        APIService.shared.filterCities(by: name, page: page) { result in
            switch result {
                
            case .success(let response):
                self.cities = response.data.items
            case .failure(let error):
                self.errorText = error.localizedDescription
            }
        }
    }
}

extension APIService {
    func getCities(page: Int, completion: @escaping ((Result<WorldCities, Error>) -> Void)) {
        request(request: .fetchCities(page: "\(page)"), completion: completion)
    }
    
    func filterCities(by name: String, page: Int, completion: @escaping ((Result<WorldCities, Error>) -> Void)) {
        request(request: .getFilteredCities(name: name, page: "\(page)"), completion: completion)
    }
}
