//
//  MoodListViewController.swift
//  Moody
//
//  Created by Carl on 2022/8/15.
//

import UIKit
import CoreData
import SnapKit

class MoodListViewController: UIViewController {
    var managedObjectContext: NSManagedObjectContext!
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.rowHeight = 64.0
        tableView.register(MoodTableViewCell.self, forCellReuseIdentifier: "MoodCell")
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndex = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndex, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        setupTableView()
    }
        
    // MARK: Private
    fileprivate var dataSource: TableViewDataSource<MoodListViewController>!
    
    fileprivate func setupTableView() {
        let request = Mood.sortedFetchRequest
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        dataSource = TableViewDataSource(tableView: self.tableView, cellIdentifier: "MoodCell", fetchedResultsController: frc, delegate: self)
        tableView.delegate = self
    }
}

extension MoodListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let mood = dataSource.selectedObject else {
            fatalError("Showing detail, but no selected row?")
        }
        
        let detailController = MoodDetailViewController()
        detailController.mood = mood
        navigationController?.pushViewController(detailController, animated: true)
    }
}

extension MoodListViewController: TableViewDataSourceDelegate {
    func configure(_ cell: MoodTableViewCell, for object: Mood) {
        cell.configure(for: object)
    }
}
