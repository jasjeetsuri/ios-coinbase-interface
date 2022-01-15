//
//  CurrencyTableViewCell.swift
//  BTC Watch
//
//  Created by Jasjeet Suri on 18/11/2017.
//  Copyright © 2017 Jastech Ltd. All rights reserved.
//

import UIKit

class RecurringAmountTableViewCell: UITableViewCell {

  //MARK: Outlets
  
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var amountText: UITextField!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.reset()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.reset()
  }
  
  func reset() {
    self.amountLabel.text = nil
    self.amountText.text = nil
    //amountPicker.selectRow(0, inComponent: 1, animated: false)
  }
}
