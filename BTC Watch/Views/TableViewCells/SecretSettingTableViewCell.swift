//
//  SecretSettingTableViewCell.swift
//  BTC Watch
//
//  Created by Jas on 01/01/2022.
//  Copyright © 2022 Jastech Ltd. All rights reserved.
//

import UIKit

class SecretSettingTableViewCell: UITableViewCell {
  
  //MARK: Outlets
  
  @IBOutlet weak var secretTextField: UITextField!
  @IBOutlet weak var secretLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    self.reset()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.reset()
  }
  
  func reset() {
    self.secretTextField.text = nil
    self.secretLabel.text = nil
  }
}
