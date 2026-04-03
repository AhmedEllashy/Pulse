//
//  PortfolioItemCell.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 01/04/2026.
//

import UIKit

final class PortfolioItemCell: UITableViewCell {
    static let reuseID = "PortfolioItemCell"

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

    private let quantityLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.textAlignment = .right
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let avgPriceLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .medium)
        l.textAlignment = .right
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        [symbolLabel, nameLabel, quantityLabel, avgPriceLabel].forEach {
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            nameLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 2),
            nameLabel.leadingAnchor.constraint(equalTo: symbolLabel.leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            avgPriceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            avgPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            quantityLabel.topAnchor.constraint(equalTo: avgPriceLabel.bottomAnchor, constant: 2),
            quantityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            quantityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with item: PortfolioItem) {
        symbolLabel.text = item.asset?.symbol
        nameLabel.text = item.asset?.name
        quantityLabel.text = "\(item.quantity) shares"
        avgPriceLabel.text = item.averageBuyPrice.formatted(.currency(code: "USD"))
    }
}
