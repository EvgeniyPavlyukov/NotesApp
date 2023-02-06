//
//  EditingNotesView.swift
//  Notes
//
//  Created by Eвгений Павлюков on 03.02.2023.
//

import UIKit

protocol EditingNotesDelegate: AnyObject {
    func obtainNewNoteData(title: String, text: String)
}

class EditingNotesViewController: UIViewController {
  
    weak var delegate: EditingNotesDelegate?
    
    var noteTitleTextField: UITextField = {
        var noteTitleTextField = UITextField()
        noteTitleTextField.backgroundColor = backgroundCollor
        noteTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        noteTitleTextField.borderStyle = .roundedRect
        noteTitleTextField.layer.cornerRadius = 5.0
        noteTitleTextField.layer.borderColor = CGColor(gray: 1, alpha: 0)
        noteTitleTextField.layer.borderWidth = 1.5
        noteTitleTextField.attributedPlaceholder = NSAttributedString(string: "Put Title Of Your Note",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        noteTitleTextField.textColor = .black
        noteTitleTextField.font = .boldSystemFont(ofSize: 30)
        noteTitleTextField.adjustsFontSizeToFitWidth = true
        
        return noteTitleTextField
    }()
    
    var noteContentTextView: UITextView = {
        var noteContentTextView = UITextView()
        noteContentTextView.translatesAutoresizingMaskIntoConstraints = false
        noteContentTextView.backgroundColor = UIColor(red: 245/255, green: 244/255, blue: 241/255, alpha: 1)
        noteContentTextView.textColor = .lightGray
        noteContentTextView.text = "Please type your note"
        noteContentTextView.font = .systemFont(ofSize: 25)
        
        return noteContentTextView
    }()
    
    override func viewDidLoad() {
        setUpNavBar()
        noteTitleTextField.delegate = self
        noteContentTextView.delegate = self
        view.addSubview(noteTitleTextField)
        view.addSubview(noteContentTextView)
        addConstraints()
        
    }

    
    func setUpNavBar() {
        view.backgroundColor = backgroundCollor
        navigationItem.largeTitleDisplayMode = .never
        let textAttributes = [NSAttributedString.Key.foregroundColor: textColorConstant]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        title = "New Note"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNewNote))
        navigationItem.rightBarButtonItem?.tintColor = colorForButtons
        self.navigationController?.navigationBar.tintColor = colorForButtons
    }
    
    @objc func saveNewNote() {
        
        if let title = noteTitleTextField.text, !noteContentTextView.text.isEmpty, !title.isEmpty {
            let text = noteContentTextView.text!
            self.delegate?.obtainNewNoteData(title: title, text: text)
            noteTitleTextField.text?.removeAll()
            noteContentTextView.text.removeAll()
            navigationController?.popViewController(animated: true)
            
        } else {
            print("Error Data")
        }

    }
    
    func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        //constraint for textField
        constraints.append(noteTitleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15.0))
        constraints.append(noteTitleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15.0))
        constraints.append(noteTitleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15.0))
        constraints.append(noteTitleTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -500.0))
        
        
        
        //constraints for textView
        constraints.append(noteContentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15.0))
        constraints.append(noteContentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15.0))
        constraints.append(noteContentTextView.topAnchor.constraint(equalTo: noteTitleTextField.bottomAnchor, constant: 15.0))
        constraints.append(noteContentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40.0))
        
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension EditingNotesViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) { //это имитация плейсхолдера
        if noteContentTextView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
}
