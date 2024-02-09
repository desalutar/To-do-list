//
//  TableViewCell.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 23.01.24.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    func toggleTaskAtSection(_ cell: Cell)
}

class Cell: UITableViewCell {

    @IBOutlet weak var todoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var circleButton: UIButton!
    
    weak var delegate: TableViewCellDelegate?
    
    static let cellID = String(describing: Cell.self)
    static func nib() -> UINib {
        return UINib(nibName: "Cell", bundle: nil )
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
    }
    
    func configureCell(with todoItem: ToDoItem) {
        titleLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.adjustsFontSizeToFitWidth = true
        dateLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel.text = todoItem.title
        descriptionLabel.text = todoItem.description
        dateLabel.text = todoItem.date?.stringValue
        
        setupLabels(todoItem)
        setupButton(todoItem)
        configureImageViewInCell(with: todoItem)
    }
    
    func configureImageViewInCell(with toDoItem: ToDoItem) {
        todoImageView.isHidden = toDoItem.imageData == nil
        guard let pictureFromData = toDoItem.imageData,
              let picture = UIImage(data: pictureFromData) else { return }
        todoImageView.image = picture
        todoImageView.layer.cornerRadius = todoImageView.frame.size.height / 2
        todoImageView.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        todoImageView.image = nil
    }
    
    func setupLabels(_ toDoItem: ToDoItem) {
        let textColor = toDoItem.isCompleted ? UIColor.systemGray4 : UIColor.label
        titleLabel.textColor = textColor
        descriptionLabel.textColor = textColor
    }
    
    func setupButton(_ todoItem: ToDoItem) {
        let circle = UIImage(systemName: "circle")
        let checkMarkCircle = "checkmark.circle.fill"
        let circleCheckMark = UIImage(systemName: checkMarkCircle)
        let buttonImage = todoItem.isCompleted ? circleCheckMark : circle
        circleButton.setImage(buttonImage, for: .normal)
    }
    
    @IBAction func circleButtonAction(_ sender: Any) {
        delegate?.toggleTaskAtSection(self)
    }
}
