//
//  DetailView.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 05/08/25.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class DetailView: UIViewController {
    
    @IBOutlet weak var topAppBarView: TopAppBarView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var typeStackView: UIStackView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var weightValueLabel: UILabel!
    @IBOutlet weak var heightValueLabel: UILabel!
    @IBOutlet weak var movesStackView: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var statsStackView: UIStackView!
    @IBOutlet weak var baseStatsLabel: UILabel!
    
    var viewModel: DetailViewModel!
    var disposeBag: DisposeBag = DisposeBag()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: DetailView.self), bundle: Bundle(for: DetailView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingVM()
        setupUI()
        viewModel.fetchPokemonDetail()
    }
    
    func setupUI() {
        setupUIInformationView()
        setupUIImageView()
    }
    
    func setupUIImageView() {
        imageView.contentMode = .scaleAspectFill
    }
    
    func setupUIInformationView() {
        informationView.layer.cornerRadius = 16
        informationView.layer.masksToBounds = true
    }
    
    func bindingVM() {
        bindingVMToTopAppBar()
        bindingVMToUI()
    }
    
    func bindingVMToTopAppBar() {
        // Title
        viewModel.pokemonObserve
            .observe(on: MainScheduler.instance)
            .map{ $0.name }
            .bind(to: topAppBarView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        // ID
        viewModel.pokemonObserve
            .observe(on: MainScheduler.instance)
            .map{ "#\($0.id)" }
            .bind(to: topAppBarView.idLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindingVMToUI() {
        // Color
        let colorObservable = viewModel.pokemonObserve
            .observe(on: MainScheduler.instance)
            .map { PokemonColorMapper.uiColor(for: $0.color ?? "gray") }
        
        colorObservable
            .bind(to: topAppBarView.rx.backgroundColor)
            .disposed(by: disposeBag)
        colorObservable
            .bind(to: topAppBarView.contentView.rx.backgroundColor)
            .disposed(by: disposeBag)
        colorObservable
            .bind(to: view.rx.backgroundColor)
            .disposed(by: disposeBag)
        colorObservable
            .bind(to: containerView.rx.backgroundColor)
            .disposed(by: disposeBag)
        colorObservable
            .bind(to: contentView.rx.backgroundColor)
            .disposed(by: disposeBag)
        colorObservable
            .bind(to: aboutLabel.rx.textColor)
            .disposed(by: disposeBag)
        colorObservable
            .bind(to: aboutLabel.rx.textColor)
            .disposed(by: disposeBag)
        colorObservable
            .bind(to: baseStatsLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        // Image
        let imageUrlObservable = viewModel.pokemonObserve
            .map { URL(string: $0.imageURL ?? "") }
            .observe(on: MainScheduler.instance)
        
        let placeholderImage = UIImage(systemName: "photo")?
            .withRenderingMode(.alwaysTemplate)
            .withTintColor(.black, renderingMode: .alwaysOriginal)
        
        imageUrlObservable
            .subscribe(onNext: { [weak self] url in
                self?.imageView.kf.setImage(
                    with: url,
                    placeholder: placeholderImage
                )
            })
            .disposed(by: disposeBag)
        
        // Types
        viewModel.pokemonObserve
            .observe(on: MainScheduler.instance)
            .map { $0.types }
            .subscribe(onNext: { [weak self] types in
                guard let self = self else { return }
                
                self.typeStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                
                for type in types {
                    let badgeView = createTypeBadgeView(typeName: type.name)
                    self.typeStackView.addArrangedSubview(badgeView)
                }
            })
            .disposed(by: disposeBag)
        
        // Moves
        viewModel.pokemonObserve
            .observe(on: MainScheduler.instance)
            .map { $0.abilities }
            .subscribe(onNext: { [weak self] abilities in
                guard let self = self else { return }
                
                self.movesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                
                for ability in abilities {
                    let label = UILabel()
                    label.text = ability.name.capitalized
                    label.textColor = .black
                    label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
                    label.textAlignment = .center
                    self.movesStackView.addArrangedSubview(label)
                }
            })
            .disposed(by: disposeBag)
        
        // Weight
        viewModel.pokemonObserve
            .observe(on: MainScheduler.instance)
            .map { $0.weight }
            .bind(to: weightValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Height
        viewModel.pokemonObserve
            .observe(on: MainScheduler.instance)
            .map { $0.height }
            .bind(to: heightValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Description
        viewModel.pokemonObserve
            .observe(on: MainScheduler.instance)
            .map { $0.description }
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Stats
        viewModel.pokemonObserve
            .observe(on: MainScheduler.instance)
            .map { $0.stats }
            .subscribe(onNext: { [weak self] stats in
                guard let self = self else { return }
                
                self.statsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                
                for stat in stats {
                    let shortName = PokemonStatNameMapper.shortName(for: stat.name)

                    let statView = PokemonStatView(statName: shortName, statValue: stat.baseStat)
                    statsStackView.addArrangedSubview(statView)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func createTypeBadgeView(typeName: String) -> UIView {
        let container = UIView()
        container.backgroundColor = PokemonTypeColorMapper.color(for: typeName)
        container.layer.cornerRadius = 12
        container.layer.masksToBounds = true
        
        let label = UILabel()
        label.text = typeName.capitalized
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8)
        ])
        
        return container
    }
    
    
}
