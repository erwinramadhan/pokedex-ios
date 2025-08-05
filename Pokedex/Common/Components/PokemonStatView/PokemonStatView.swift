//
//  PokemonStatView.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 06/08/25.
//

import UIKit

class PokemonStatView: UIView {

    private let nameLabel = UILabel()
    private let valueLabel = UILabel()
    private let progressBackground = UIView()
    private let progressBar = UIView()

    private let maxStatValue: CGFloat = 100

    init(statName: String, statValue: Int) {
        super.init(frame: .zero)
        setupView()
        configure(statName: statName, statValue: statValue)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        // Stack horizontal utama
        let stack = UIStackView(arrangedSubviews: [nameLabel, valueLabel, progressBackground])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fill

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        // Label stat name
        nameLabel.font = .boldSystemFont(ofSize: 14)
        nameLabel.textColor = UIColor.systemGreen
        nameLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        nameLabel.textAlignment = .right

        // Label stat value
        valueLabel.font = .systemFont(ofSize: 14, weight: .medium)
        valueLabel.textColor = .black
        valueLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        valueLabel.textAlignment = .left

        // Background bar
        progressBackground.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
        progressBackground.layer.cornerRadius = 4
        progressBackground.translatesAutoresizingMaskIntoConstraints = false
        progressBackground.heightAnchor.constraint(equalToConstant: 8).isActive = true

        // Add bar ke dalam background
        progressBackground.addSubview(progressBar)
        progressBar.backgroundColor = UIColor.systemGreen
        progressBar.layer.cornerRadius = 4
        progressBar.translatesAutoresizingMaskIntoConstraints = false
    }

    private var progressBarWidthConstraint: NSLayoutConstraint?

    private func configure(statName: String, statValue: Int) {
        nameLabel.text = statName
        valueLabel.text = String(format: "%03d", statValue)

        // Update progress bar lebar berdasarkan nilai stat
        layoutIfNeeded()
        let percentage = min(CGFloat(statValue) / maxStatValue, 1.0)

        progressBarWidthConstraint?.isActive = false
        progressBar.removeConstraints(progressBar.constraints)

        progressBarWidthConstraint = progressBar.widthAnchor.constraint(equalTo: progressBackground.widthAnchor, multiplier: percentage)
        progressBarWidthConstraint?.isActive = true

        NSLayoutConstraint.activate([
            progressBar.topAnchor.constraint(equalTo: progressBackground.topAnchor),
            progressBar.bottomAnchor.constraint(equalTo: progressBackground.bottomAnchor),
            progressBar.leadingAnchor.constraint(equalTo: progressBackground.leadingAnchor)
        ])
    }
}
