//
//  BranchOfficeCell.swift
//  KosmosBank
//
//  Created by Sergey V. Krupov on 18.08.17.
//
//

import UIKit
import RxSwift
import CoreLocation

class BranchOfficeCell: UITableViewCell {

    //MARK: - Dependencies
    
    var locationService: ILocationService!
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var workingHoursLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    //MARK: - Public
    
    func setupWith(_ branchOffice: BranchOffice) {
        titleLabel.text = branchOffice.title
        addressLabel.text = branchOffice.address
        workingHoursLabel.text = branchOffice.workingHours
        distanceLabel.isHidden = true
        
        _bag = DisposeBag()
        locationService.observeLocation()
        .distinctUntilChanged { (location1, location2) -> Bool in
            if let l1 = location1, let l2 = location2 {
                return l1 == l2
            }
            return location1 == nil && location2 == nil
        }
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] location in
            guard let this = self else { return }
            guard let loc = location else {
                this.distanceLabel.isHidden = true
                return
            }
            this.distanceLabel.isHidden = false
            let l1 = CLLocation(loc)
            let l2 = CLLocation(branchOffice.location)
            let distance = l1.distance(from: l2)
            this.distanceLabel.text = "Расстояние: \(distance)м"
            
        })
        .addDisposableTo(_bag)
    }
    
    //MARK: - Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        BranchOfficeCellAssembly.instance().inject(into: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        _bag = nil
    }
    
    //MARK: - Private
    
    private var _bag: DisposeBag!
    
}
