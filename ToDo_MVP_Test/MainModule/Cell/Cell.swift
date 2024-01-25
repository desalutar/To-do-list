//
//  TableViewCell.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 23.01.24.
//

import UIKit

class Cell: UITableViewCell {

    @IBOutlet weak var todoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var circleButton: UIButton!
    
    
    static let cellID = String(describing: Cell.self)
    static func nib() -> UINib {
        return UINib(nibName: "Cell", bundle: nil )
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
        todoImageView.isHidden = true
    }
    
    func configureCell(with todoItem: ToDoItem) {
        titleLabel.text = todoItem.title
        descriptionLabel.text = todoItem.description
        dateLabel.text = todoItem.date?.stringValue
        setupLabels(todoItem)
        setupButton(todoItem)
        configureImageView(with: todoItem)
    }
    
    func configureImageView(with toDoItem: ToDoItem) {
           todoImageView.layer.cornerRadius = todoImageView.frame.size.height / 2
           todoImageView.layer.masksToBounds = true
       }

    
    func setupLabels(_ toDoItem: ToDoItem) {
        let textColor = toDoItem.isCompleted ? UIColor.systemGray4 : UIColor.label
        titleLabel.textColor = textColor
        descriptionLabel.textColor = textColor
    }
    
    func setupButton(_ todoItem: ToDoItem) { // button settings for choice
        let circle = UIImage(systemName: "circle")
        let checkMarkCircle = "checkmark.circle.fill"
        let circleCheckMark = UIImage(systemName: checkMarkCircle)
        let buttonImage = todoItem.isCompleted ? circleCheckMark : circle
        circleButton.setImage(buttonImage, for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        todoImageView.image = nil
    }
    
    @IBAction func circleButtonAction(_ sender: Any) {
        print("123")
        /*
         делегат нажатия на ячейку для перехода в секцию завершенных и обратно
        */
    }
}
