//
//  CurrencyTableViewCell.swift
//  BTC Watch
//
//  Created by Jasjeet Suri on 18/11/2017.
//  Copyright © 2017 Jastech Ltd. All rights reserved.
//

import UIKit

class FrequencyTableViewCell: UITableViewCell {

  //MARK: Outlets
  
  @IBOutlet weak var frequencyLabel: UILabel!
  @IBOutlet weak var frequencyPicker: UIPickerView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.reset()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.reset()
  }
  
  func reset() {
    self.frequencyLabel.text = nil
    //self.menuLabel.text = nil
  }
}
