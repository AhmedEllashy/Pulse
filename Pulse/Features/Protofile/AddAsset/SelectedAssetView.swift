//
//  SelectedAssetView.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 03/04/2026.
//


import UIKit

final class SelectedAssetView: UIView {

    private let symbolLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18, weight: .bold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        addSubview(symbolLabel)
        addSubview(nameLabel)

        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            symbolLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            nameLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 2),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }

    func configure(with asset: Asset) {
        symbolLabel.text = asset.symbol
        nameLabel.text = asset.name
    }
}
