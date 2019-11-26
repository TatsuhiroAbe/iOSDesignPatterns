//
//  RepositoryCell.swift
//  iOSDesignPatterns
//
//  Created by 阿部竜大 on 2019/11/25.
//  Copyright © 2019 阿部竜大. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ repository: Repository) {
        nameLabel.text = repository.name
        languageLabel.text = repository.language
        descriptionLabel.text = repository.description
    }
}
