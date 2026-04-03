//
//  PortfolioHeaderView.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 01/04/2026.
//

import UIKit

final class PortfolioHeaderView: UIView {

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Total Value"
        l.font = .systemFont(ofSize: 14)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let valueLabel: UILabel = {
        let l = UILabel()
        l.text = "$0.00"
        l.font = .systemFont(ofSize: 34, weight: .bold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        backgroundColor = .systemGroupedBackground
        addSubview(titleLabel)
        addSubview(valueLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }

    func configure(totalValue: Double) {
        valueLabel.text = totalValue.formatted(.currency(code: "USD"))
    }
}
