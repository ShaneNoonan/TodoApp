//
//  AddToDoViewController.swift
//  ToDoApp
//
//  Created by Shane Noonan on 18/03/2018.
//  Copyright © 2018 Shane Noonan. All rights reserved.
//

import UIKit
import CoreData

class AddToDoViewController: UIViewController {
    
    // MARK: Properties
    var managedContext: NSManagedObjectContext!
    var todo: ToDo?
    
    // MARK: Outlets
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(with:)),
            name: .UIKeyboardWillShow,
            object: nil)
        
        textView.becomeFirstResponder()
        
        if let todo = todo {
            //bug
            textView.text = todo.title
            textView.text = todo.title
            
            segmentControl.selectedSegmentIndex = Int(todo.priority)
            
        }
    }
    
    // MARK: Actions
    
    @objc func keyboardWillShow(with notification: Notification) {
     
        let key = "UIKeyboardFrameEndUserInfoKey"
     
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else { return }
     
        let keyboardHeight = keyboardFrame.cgRectValue.height
     
        bottomConstraint.constant = keyboardHeight + 16
     
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
    }
     
    }

    @IBAction func cancel(_ sender: Any) {
        
        dismissAndResign()
    }
    
    fileprivate func dismissAndResign() {
        dismiss(animated: true)
        textView.resignFirstResponder()
    }
    
    @IBAction func done(_ sender: Any) {
        
        guard let title = textView.text, !title.isEmpty else {
            return
        }
        
        if let todo = self.todo {
            todo.title = title
            todo.priority = Int16(segmentControl.selectedSegmentIndex)
        } else {
        let todo = ToDo(context: managedContext)
        todo.title = title
        todo.priority = Int16(segmentControl.selectedSegmentIndex)
        todo.date = Date()
        }
        
        do {
            try managedContext.save()
            dismissAndResign()
        }
        catch {
            print("Saving todo errors: \(error)")
        }
        
    }

}

extension AddToDoViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if doneButton.isHidden {
            textView.text.removeAll()
            textView.textColor = .white
            
            doneButton.isHidden = false
            
            UIView.animate(withDuration: 0.3){
                self.view.layoutIfNeeded()
            }
        }
    }
}
