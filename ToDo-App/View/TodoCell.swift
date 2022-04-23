//
//  TodoCell.swift
//  ToDo-App
//
//  Created by Jadson on 22/04/22.
//

import UIKit

class TodoCell: UITableViewCell {
    
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var priorityView: UIView!

    func updateCel(todo: Todo) {
        itemLbl.text = todo.item
        
        switch todo.priority {
        case 0:
            priorityView.backgroundColor = .yellow
            break
        case 1:
            priorityView.backgroundColor = .orange
        case 2:
            priorityView.backgroundColor = .red
        default:
            priorityView.backgroundColor = .white
        }
    }

}
