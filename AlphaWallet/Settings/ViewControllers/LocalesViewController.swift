// Copyright © 2018 Stormbird PTE. LTD.

import UIKit

protocol LocalesViewControllerDelegate: class {
    func didSelect(locale: AppLocale, in viewController: LocalesViewController)
}

class LocalesViewController: UIViewController {
    private let roundedBackground = RoundedBackground()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var viewModel: LocalesViewModel?

    weak var delegate: LocalesViewControllerDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = Colors.appBackground

        roundedBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(roundedBackground)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = GroupedTable.Color.background
        tableView.register(LocaleViewCell.self, forCellReuseIdentifier: LocaleViewCell.identifier)
        roundedBackground.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: roundedBackground.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: roundedBackground.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: roundedBackground.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ] + roundedBackground.createConstraintsWithContainer(view: view))
    }

    func configure(viewModel: LocalesViewModel) {
        self.viewModel = viewModel
        tableView.dataSource = self
        title = viewModel.title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LocalesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.locales.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocaleViewCell.identifier, for: indexPath) as! LocaleViewCell
        if let viewModel = viewModel {
            let locale = viewModel.locale(for: indexPath)
            let cellViewModel = LocaleViewModel(locale: locale, selected: viewModel.isLocaleSelected(locale))
            cell.configure(viewModel: cellViewModel)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModel = viewModel else { return }
        let locale = viewModel.locale(for: indexPath)
        delegate?.didSelect(locale: locale, in: self)
    }
}
