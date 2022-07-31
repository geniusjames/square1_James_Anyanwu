//
//  CountryListViewController.swift
//  Assessment
//
//  Created by Geniusjames on 31/07/2022.
//

import UIKit
import Combine

class CityListViewController: UIViewController {
    
    @IBOutlet weak var countryListTableView: UITableView!
    private typealias DataSource = UITableViewDiffableDataSource<CountrySection, City>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<CountrySection, City>
    private var cancellables: Set<AnyCancellable> = []
    private var dataSource: DataSource!
    @IBOutlet weak var searchBar: UISearchBar!
    var viewModel: CityViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = makeDataSource()
        countryListTableView.register(ListTableViewCell.toNib(), forCellReuseIdentifier: ListTableViewCell.identifier)
        countryListTableView.delegate = self
        viewModel.fetchCities(onPage: 1)
        searchBar.delegate = self
        applySnapshot()
        setupObservers()
    }
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(tableView: countryListTableView, cellProvider: { (tableView, indexPath, city) -> UITableViewCell? in
  
            let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell
            cell?.setup(with: city)
            return cell
        })
        dataSource.defaultRowAnimation = .fade
       return dataSource
    }
   
    private func applySnapshot(animatingDifferences: Bool = true) {
    
        var snapshot = Snapshot()
        
        snapshot.appendSections([.countries])
        snapshot.appendItems(viewModel.cities)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
//        adjustEmptyState()
    }
    
    private func setupObservers() {
        viewModel.$cities
            .receive(on: RunLoop.main)
            .compactMap( { $0 })
            .sink(receiveValue:  {
                self.applySnapshot()
            })
            .store(in: &cancellables)
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
}

extension CityListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CityListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > (countryListTableView.contentSize.height - 100 - scrollView.frame.height) {
            if viewModel.currentPage < viewModel.total {
                if !viewModel.isLoading {
                    viewModel.fetchCities(onPage: viewModel.currentPage + 1)
                }
                viewModel.isLoading = true
            }
        }
        
        if position < 10 {
            if viewModel.currentPage > 1 {
                if !viewModel.isLoading {
                    viewModel.fetchCities(onPage: viewModel.currentPage - 1)
                }
                viewModel.isLoading = true

            }
            print("reached")
        }
    }
}

extension CityListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchCities(name: searchText, page: 1)
    }
}
