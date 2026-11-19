//
//  TaskCell.swift
//  TestTask
//
//

import UIKit

class TaskCell: UITableViewCell {
    static let reuseIdentifier: String = "TaskCell"
    
    var onCompletionTapped: (() -> Void)?

    private let completionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemBlue
        button.accessibilityLabel = "Статус задачи"
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private let creationDateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        return label
    }()

    private let priorityLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        return label
    }()

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    func configure(with task: ListTaskModel) {
        titleLabel.text = task.name
        descriptionLabel.text = task.description
        creationDateLabel.text = Self.dateFormatter.string(from: task.date)

        switch task.priority {
        case .low:
            priorityLabel.text = "Низкий"
        case .medium:
            priorityLabel.text = "Средний"
        case .high:
            priorityLabel.text = "Высокий"
        }

        let symbolName = task.isCompleted ? "checkmark.circle.fill" : "circle"
        completionButton.setImage(UIImage(systemName: symbolName), for: .normal)
    }

    private func setupLayout() {
        selectionStyle = .none

        let detailsStack = UIStackView(arrangedSubviews: [creationDateLabel, priorityLabel])
        detailsStack.axis = .horizontal
        detailsStack.spacing = 12

        let textStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, detailsStack])
        textStack.axis = .vertical
        textStack.spacing = 6

        contentView.addSubview(completionButton)
        contentView.addSubview(textStack)
        completionButton.translatesAutoresizingMaskIntoConstraints = false
        completionButton.addTarget(self, action: #selector(didTapCompletion), for: .touchUpInside)
        textStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            completionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            completionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            completionButton.widthAnchor.constraint(equalToConstant: 28),
            completionButton.heightAnchor.constraint(equalToConstant: 28),

            textStack.leadingAnchor.constraint(equalTo: completionButton.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            textStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: completionButton.bottomAnchor, constant: 16)
        ])
    }
    
    @objc func didTapCompletion() {
        onCompletionTapped?()
    }
}
