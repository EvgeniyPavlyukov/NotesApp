//
//  DetailedViewController.swift
//  Notes
//
//  Created by Eвгений Павлюков on 06.02.2023.
//

import Foundation
import UIKit


class DetailedViewController: UIViewController {
    
    var detailedTitleTextField: UITextField = {
        var detailedTitleTextField = UITextField()
        detailedTitleTextField.backgroundColor = backgroundCollor
        detailedTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        detailedTitleTextField.borderStyle = .roundedRect
        detailedTitleTextField.layer.cornerRadius = 5.0
        detailedTitleTextField.layer.borderColor = CGColor(gray: 1, alpha: 0)
        detailedTitleTextField.layer.borderWidth = 1.5
        detailedTitleTextField.attributedPlaceholder = NSAttributedString(string: "Put Title Of Your Note",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        detailedTitleTextField.textColor = .black
        detailedTitleTextField.font = .boldSystemFont(ofSize: 30)
        detailedTitleTextField.adjustsFontSizeToFitWidth = true
        
        return detailedTitleTextField
    }()
    
    
    
    var detailedContentTextView: UITextView = {
        var detailedContentTextView = UITextView()
        detailedContentTextView.translatesAutoresizingMaskIntoConstraints = false
        detailedContentTextView.backgroundColor = UIColor(red: 245/255, green: 244/255, blue: 241/255, alpha: 1)
        detailedContentTextView.textColor = .lightGray
        detailedContentTextView.text = "Please type your note"
        detailedContentTextView.font = .systemFont(ofSize: 25)
        
        return detailedContentTextView
    }()
    
    deinit {
        print("DetailedVC is destroied")
    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Detailed VC")
        
        setUpNavBar()
        self.view.addSubview(detailedTitleTextField)
        self.view.addSubview(detailedContentTextView)
        detailedContentTextView.text = "detailedText"
        detailedTitleTextField.text = "detailedTitle"
        detailedTitleTextField.delegate = self
        detailedContentTextView.delegate = self
        
        detailedTitleTextField.attributedPlaceholder = NSAttributedString(string: "detailedTitle",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        detailedContentTextView.text = "detailedText"
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
        
        if let title = detailedTitleTextField.text, !detailedContentTextView.text.isEmpty, !title.isEmpty {
            let text = detailedContentTextView.text!
            let notesTuple = (title, text)
        
            navigationController?.popViewController(animated: true)
            
        } else {
            print("Error Data")
        }

    }
    
    func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        //constraint for textField
        constraints.append(detailedTitleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15.0))
        constraints.append(detailedTitleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15.0))
        constraints.append(detailedTitleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15.0))
        constraints.append(detailedTitleTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -500.0))
        
        
        
        //constraints for textView
        constraints.append(detailedContentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15.0))
        constraints.append(detailedContentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15.0))
        constraints.append(detailedContentTextView.topAnchor.constraint(equalTo: detailedTitleTextField.bottomAnchor, constant: 15.0))
        constraints.append(detailedContentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40.0))
        
        NSLayoutConstraint.activate(constraints)
    }

    
    
//    func passDataToDetailedVC(detailedTitle: String, detailedText: String) {
//        self.detailedTitle = detailedTitle
//        self.detailedText = detailedText
//    }
    
    
}

extension DetailedViewController: UITextViewDelegate, UITextFieldDelegate {
    
}
