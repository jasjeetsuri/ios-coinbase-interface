//
//  SecretSettingTableViewCell.swift
//  BTC Watch
//
//  Created by Jas on 01/01/2022.
//  Copyright © 2022 Jastech Ltd. All rights reserved.
//

import UIKit

class PassphraseTableViewCell: UITableViewCell {
  
  //MARK: Outlets
  
  @IBOutlet weak var passphraseTextField: UITextField!
  @IBOutlet weak var passphraseLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    self.reset()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.reset()
  }
  
  func reset() {
    self.passphraseTextField.text = nil
    self.passphraseLabel.text = nil
  }
}
