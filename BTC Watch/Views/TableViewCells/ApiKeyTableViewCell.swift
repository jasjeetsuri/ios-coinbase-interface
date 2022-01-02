//
//  SecretSettingTableViewCell.swift
//  BTC Watch
//
//  Created by Jas on 01/01/2022.
//  Copyright © 2022 Jastech Ltd. All rights reserved.
//

import UIKit

class ApiKeyTableViewCell: UITableViewCell {
  
  //MARK: Outlets
  
  @IBOutlet weak var apiKeyTextField: UITextField!
  @IBOutlet weak var apiKeyLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.reset()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.reset()
  }
  
  func reset() {
    self.apiKeyTextField.text = nil
    self.apiKeyLabel.text = nil
  }
}
