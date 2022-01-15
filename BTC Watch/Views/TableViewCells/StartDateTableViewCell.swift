//
//  CurrencyTableViewCell.swift
//  BTC Watch
//
//  Created by Jasjeet Suri on 18/11/2017.
//  Copyright © 2017 Jastech Ltd. All rights reserved.
//

import UIKit

class StartDateTableViewCell: UITableViewCell {

  //MARK: Outlets
  
  @IBOutlet weak var startDateLabel: UILabel!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.reset()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.reset()
  }
  
  func reset() {
    self.startDateLabel.text = nil
    //self.menuLabel.text = nil
  }
}
