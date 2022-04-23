//
//  ViewController.swift
//  ToDo-App
//
//  Created by Jadson on 21/04/22.
//

import UIKit

class TodoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var todoItemTxt: UITextField!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    @IBOutlet weak var todoTable: UITableView!
    
    var todos = Array<Todo>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoTable.delegate = self
        todoTable.dataSource = self
        getTodos()
        


        
    }
    
    func getTodos() {
       
        NetworkService.shared.getTodos { todos in
            self.todos = todos.items
            self.todoTable.reloadData()
        } onError: { (errorMessage) in
            debugPrint(errorMessage)
        }

    }
    
    @IBAction func addTodo(_ sender: Any) {
        guard let todoItem = todoItemTxt.text else {return}
        
        let newTodoItem = Todo(item: todoItem, priority: prioritySegment.selectedSegmentIndex)
        NetworkService.shared.addTodo(todo: newTodoItem) { todos in
            self.todoItemTxt.text = "" //reset it to empty 
            self.todos = todos.items
            self.todoTable.reloadData()
        } onError: { (errorMessage) in
            debugPrint(errorMessage)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as? TodoCell {
            cell.updateCel(todo: todos[indexPath.row])
            return cell
        }
        return TodoCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

