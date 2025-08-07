//
//  ProfileView.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import RxCocoa

class ProfileView: UIViewController {
    
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var avatarLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var trainerIdLabel: UILabel!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: View Model
    var viewModel: ProfileViewModel!
    let disposeBag = DisposeBag()
    
    // MARK: Navigation Callback Closure
    var navigateToDetail: ((_ selectedPokemon: PokemonListItem) -> Void)?
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ProfileView.self), bundle: Bundle(for: ProfileView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.getProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavoritesPokemon()
    }
    
    func setupUI() {
        avatarView.layer.cornerRadius = avatarView.frame.width / 2
        avatarView.layer.masksToBounds = true
        
        mainStackView.layer.cornerRadius = 16
        mainStackView.layer.masksToBounds = true
        
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.setTitleColor(.lightGray, for: .highlighted)
        logoutButton.setTitleColor(.lightGray, for: .selected)
        logoutButton.backgroundColor = UIColor(hex: "DC0A2D", alpha: 1.0)
        logoutButton.layer.cornerRadius = 12
        logoutButton.layer.masksToBounds = true
        
        setupTableView()
        bindingVM()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "PokemonCardCell", bundle: nil), forCellReuseIdentifier: "PokemonCardCell")
        
        tableView.rx.modelSelected(PokemonListItem.self)
            .subscribe(onNext: { [weak self] selectedItem in
                self?.navigateToDetail?(selectedItem)
            })
            .disposed(by: disposeBag)
    }
    
    func bindingVM() {
        viewModel.favoritesPokemonObservable
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "PokemonCardCell", cellType: PokemonCardCell.self)) { row, element, cell in
                cell.pokemonNameLabel?.text = element.name.capitalized
                
                let placeholderImage = UIImage(systemName: "photo")?
                    .withRenderingMode(.alwaysTemplate)
                    .withTintColor(.black, renderingMode: .alwaysOriginal)
                
                if let imageUrl = URL(string: element.image) {
                    cell.pokemonImageView.kf.setImage(
                        with: imageUrl,
                        placeholder: placeholderImage
                    )
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.profileObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] profile in
                guard let self else { return }
                avatarLabel.text = getInitials(from: profile.name)
                nameLabel.text = profile.name
                trainerIdLabel.text = "Trainer ID: \(profile.id)"
            })
            .disposed(by: disposeBag)
    }
    
    private func getInitials(from fullName: String) -> String {
        return fullName
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .compactMap { $0.first }
            .map { String($0).uppercased() }
            .joined()
    }

}

extension ProfileView: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Profile")
    }
}
