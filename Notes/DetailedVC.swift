//
//  DetailedViewController.swift
//  Notes
//
//  Created by Eвгений Павлюков on 06.02.2023.
//

import Foundation
import UIKit


class DetailedViewController: UIViewController {
    
    
    //MARK: - View
    
    var detailedTitleTextField: UITextField = {
        var detailedTitleTextField = UITextField()
        detailedTitleTextField.backgroundColor = backgroundColor
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
        detailedContentTextView.textColor = .black
        detailedContentTextView.text = "Please type your note"
        detailedContentTextView.font = .systemFont(ofSize: 25)
        
        return detailedContentTextView
    }()
    
   
    
    //MARK: - Цикл экрана
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Detailed VC")
        
        setUpNavBar()
        self.view.addSubview(detailedTitleTextField)
        self.view.addSubview(detailedContentTextView)
        detailedContentTextView.text = Memory.detailedText
        detailedTitleTextField.text = Memory.detailedTitle
        detailedTitleTextField.delegate = self
        detailedContentTextView.delegate = self
        
        detailedTitleTextField.attributedPlaceholder = NSAttributedString(string: Memory.detailedTitle,
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        detailedContentTextView.text = Memory.detailedText
        addConstraints()
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    deinit {
        print("DetailedVC is destroied")
    }
    
    
    //MARK: - View set up
    
    func setUpNavBar() {
        self.view.backgroundColor = backgroundColor
        self.navigationItem.largeTitleDisplayMode = .never
        let textAttributes = [NSAttributedString.Key.foregroundColor: textColorConstant]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        title = "New Note"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNewNote))
        self.navigationItem.rightBarButtonItem?.tintColor = colorForButtons
        self.navigationController?.navigationBar.tintColor = colorForButtons
    }
    
    @objc func saveNewNote() {
        Memory.dataTuplesArray[Memory.indexCell].title = detailedTitleTextField.text ?? ""
        Memory.dataTuplesArray[Memory.indexCell].text = detailedContentTextView.text ?? ""
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Constraints
    
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
        constraints.append(detailedContentTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10.0))
        
        
        NSLayoutConstraint.activate(constraints)
    }
}


    //MARK: - TextView Delegate  

extension DetailedViewController: UITextViewDelegate, UITextFieldDelegate {
    
}

