//
//  CurrencySettingTableViewCell.swift
//  BTC Watch
//
//  Created by Jasjeet Suri on 18/11/2017.
//  Copyright © 2017 Jastech Ltd. All rights reserved.
//

import UIKit

class BlankTableViewCell: UITableViewCell {
  
  //MARK: Outlets
  

  override func awakeFromNib() {
    super.awakeFromNib()
    self.reset()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.reset()
  }
  
  func reset() {
    
  }
}
