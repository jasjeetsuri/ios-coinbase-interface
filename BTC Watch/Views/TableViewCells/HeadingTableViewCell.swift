//
//  CurrencySettingTableViewCell.swift
//  BTC Watch
//
//  Created by Jasjeet Suri on 18/11/2017.
//  Copyright © 2017 Jastech Ltd. All rights reserved.
//

import UIKit

class HeadingTableViewCell: UITableViewCell {
  
  //MARK: Outlets
  
  @IBOutlet weak var HeadingDisplayLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.reset()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.reset()
  }
  
  func reset() {
    self.HeadingDisplayLabel.text = nil
  }
}
