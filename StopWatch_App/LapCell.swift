//
//  LapCellTableViewCell.swift
//  StopWatch_App
//
//  Created by Designer on 2023/07/05.
//

import UIKit

class LapCell: UITableViewCell {

    var rememberRow = 0
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .systemGray6
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
