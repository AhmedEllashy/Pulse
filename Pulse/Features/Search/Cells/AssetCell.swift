//
//  AssetCell.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 27/03/2026.
//

import UIKit

final class AssetCell: UITableViewCell {
    static let reuseID = "AssetCell"

    private let symbolLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let typeLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 11, weight: .medium)
        l.textColor = .white
        l.textAlignment = .center
        l.layer.cornerRadius = 4
        l.clipsToBounds = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        [symbolLabel, nameLabel, typeLabel].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            nameLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 2),
            nameLabel.leadingAnchor.constraint(equalTo: symbolLabel.leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            typeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            typeLabel.widthAnchor.constraint(equalToConstant: 52),
            typeLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configure(with asset: Asset) {
        symbolLabel.text = asset.symbol
        nameLabel.text = asset.name
        typeLabel.text = asset.type.rawValue.uppercased()
        typeLabel.backgroundColor = asset.type == .stock ? .systemBlue : .systemOrange
    }
}
