//
//  HomeView.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip
import Kingfisher
import MBProgressHUD

class HomeView: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    var viewModel: HomeViewModel!
    
    // MARK: Navigation Callback Closure
    var navigateToDetail: ((_ selectedPokemon: PokemonListItem) -> Void)?
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: HomeView.self), bundle: Bundle(for: HomeView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        viewModel.fetchPokemonList()
        bindVM()
        setupContainerView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "PokemonCardCell", bundle: nil), forCellReuseIdentifier: "PokemonCardCell")
    }
    
    func setupContainerView() {
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
    }
    
    func bindVM() {
        // Bind search input to viewModel
        searchTextField.rx.text.orEmpty
            .bind(to: viewModel.searchValue)
            .disposed(by: disposeBag)
        
        viewModel.isLoadingObserve
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                guard let self = self else { return }
                
                if loading {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.pokemonObserve
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "PokemonCardCell", cellType: PokemonCardCell.self)) { row, element, cell in
                cell.pokemonNameLabel?.text = element.name.capitalized
                
                let placeholderImage = UIImage(systemName: "photo")?
                    .withRenderingMode(.alwaysTemplate)
                    .withTintColor(.black, renderingMode: .alwaysOriginal)
                
                if let imageUrl = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(element.id).png") {
                    cell.pokemonImageView.kf.setImage(
                        with: imageUrl,
                        placeholder: placeholderImage
                    )
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(PokemonListItem.self)
            .subscribe(onNext: { [weak self] selectedItem in
                self?.navigateToDetail?(selectedItem)
            })
            .disposed(by: disposeBag)
        
        bindScrollToBottom()
    }
    
    func bindScrollToBottom() {
        tableView.rx.contentOffset
            .observe(on: MainScheduler.instance)
            .filter { [weak self] offset in
                guard let self = self else { return false }
                let visibleHeight = self.tableView.frame.height
                let contentHeight = self.tableView.contentSize.height
                let yOffset = offset.y
                return yOffset + visibleHeight + 100 > contentHeight
            }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.fetchNextPage()
            })
            .disposed(by: disposeBag)
    }
    
}

extension HomeView: UIScrollViewDelegate {
    
}

extension HomeView: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Home")
    }
}
