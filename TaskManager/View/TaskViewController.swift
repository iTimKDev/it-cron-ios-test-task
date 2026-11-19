//
//  ViewController.swift
//  TestTask
//
//

import UIKit

class TaskViewController: UIViewController {

    let viewModel: TaskViewModel

    private let tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .plain
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 100
        return tableView
    }()
    
    init(viewModel: TaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        tableView.dataSource = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseIdentifier)
        viewModel.onTaskChanged = { [weak self] in
            self?.tableView.reloadData()
        }
        
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? TaskCell else { return UITableViewCell() }
        let task = viewModel.tasks[indexPath.row]
        let taskId = task.id
        cell.configure(with: task)
        cell.onCompletionTapped = { [weak self] in
            do {
                try self?.viewModel.updateStatus(id: taskId, isCompleted: !task.isCompleted)
            } catch {
                print(error)
            }
        }
        
        return cell
    }
}
