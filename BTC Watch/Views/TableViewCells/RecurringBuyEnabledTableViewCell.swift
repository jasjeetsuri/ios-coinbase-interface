//
//  CurrencyTableViewCell.swift
//  BTC Watch
//
//  Created by Jasjeet Suri on 18/11/2017.
//  Copyright © 2017 Jastech Ltd. All rights reserved.
//

import UIKit

class RecurringBuyEnabledTableViewCell: UITableViewCell {

  //MARK: Outlets
  
  @IBOutlet weak var enabledLabel: UILabel!
  @IBOutlet weak var enabledToggle: UISwitch?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.reset()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.reset()
  }
  
  func reset() {
    self.enabledLabel.text = nil
    self.enabledToggle!.setOn(false, animated: false)
  }
}
