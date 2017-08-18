//
//  ViewController.swift
//  KosmosBank
//
//  Created by Sergey V. Krupov on 17/08/2017.
//
//

import UIKit
import RxSwift

class ViewController: UITableViewController {

    //MARK: - Dependencies
    
    var apiClient: IAPIClient!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ViewControllerAssembly.instance().inject(into: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _updateDisposable.addDisposableTo(_bag)
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(updateData), for: .valueChanged)
        refreshControl?.beginRefreshing()
        updateData()
    }

    @objc func updateData() {
        _updateDisposable.disposable = apiClient.obtainBranchOffices()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] offices in
                guard let this = self else { return }
                this._branchOffices = offices
                this.tableView.reloadData()
                }, onError: { [weak self] _ in
                    self?.refreshControl?.endRefreshing()
                }, onCompleted: { [weak self] in
                    self?.refreshControl?.endRefreshing()
                })
        
    }
    
    // TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _branchOffices.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BranchOfficeCell", for: indexPath) as! BranchOfficeCell
        cell.setupWith(_branchOffices[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    //MARK: - Private
    
    private let _bag = DisposeBag()
    private var _branchOffices = Array<BranchOffice>()
    private var _updateDisposable = SerialDisposable()
}

