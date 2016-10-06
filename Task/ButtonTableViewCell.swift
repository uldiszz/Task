//
//  ButtonTableViewCell.swift
//  Task
//
//  Created by Uldis Zingis on 05/10/16.
//  Copyright © 2016 Uldis Zingis. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var completenesButton: UIButton!
    
    weak var delegate: ButtonTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateWithTask(task: Task) {
        nameLabel.text = task.name
        updateButton(isComplete: task.isComplete)
    }
    
    func updateButton(isComplete: Bool) {
        if isComplete {
            completenesButton.setImage(UIImage(named: "complete"), for: .normal)
        } else {
            completenesButton.setImage(UIImage(named: "incomplete"), for: .normal)
        }
    }
    
    @IBAction func completenesButtonTapped(_ sender: AnyObject) {
        if let delegate = delegate {
            delegate.buttonCellButtonTapped(sender: self)
        }
    }
}

protocol ButtonTableViewCellDelegate: class {
    func buttonCellButtonTapped(sender: ButtonTableViewCell)
}
