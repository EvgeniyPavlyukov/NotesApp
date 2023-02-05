//
//  ViewController.swift
//  Notes
//
//  Created by Eвгений Павлюков on 03.02.2023.
//

import UIKit

class NotesViewController: UIViewController, EditingNotesDelegate {
    
    var notesTuplesArray = [(String, String)]()
    var editingVC = EditingNotesViewController()
    
   
    
    var notesLabel: UILabel = {
        let notesLabel = UILabel()
        notesLabel.translatesAutoresizingMaskIntoConstraints = false
        notesLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 60)
        notesLabel.textAlignment = .center
        notesLabel.textColor = .black
        notesLabel.numberOfLines = 0
        notesLabel.text = "No notes yet"
        
        return notesLabel
    }()
    
    var notesTableView: UITableView = {
        let notesTableView = UITableView(frame: .zero, style: .grouped)
        notesTableView.translatesAutoresizingMaskIntoConstraints = false
        notesTableView.isHidden = true
        notesTableView.separatorStyle = .none
        notesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        notesTableView.backgroundColor = backgroundCollor
        return notesTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = backgroundCollor
        self.editingVC.delegate = self
        notesTableView.delegate = self
        notesTableView.dataSource = self
        view.addSubview(notesLabel)
        view.addSubview(notesTableView)
        navBarSetUp()
        addButtonNote()
        addConstraints()
        
    }

    func navBarSetUp() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor: textColorConstant]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        self.title = "Notes"
    }
    
    func addButtonNote() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.navigationItem.rightBarButtonItem?.tintColor = colorForButtons
        
    }
    
    @objc func addNote() {
        navigationController?.pushViewController(editingVC, animated: true)
    }
    
    func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        //constraint for TableView
        constraints.append(notesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20))
        constraints.append(notesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20))
        constraints.append(notesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(notesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)) //make table view anchor to navBar
        
        //constraints for Label
        constraints.append(notesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(notesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: - Delegate
    
    func obtainNewNoteData(title: String, text: String) {
        self.notesLabel.isHidden = true
        self.notesTableView.isHidden = false
        let notesTuple = (title, text)
        notesTuplesArray.append(notesTuple)
        UIRefreshControl().endRefreshing()
        let indexPathNewRow = IndexPath(row: notesTuplesArray.count - 1, section: 0)
        notesTableView.insertRows(at: [indexPathNewRow], with: .automatic)
        
    }
    
    
}


extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesTuplesArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
              
        let label = notesTuplesArray[indexPath.row].0
        let text = notesTuplesArray[indexPath.row].1
        var cellProperties = cell.defaultContentConfiguration()
        cellProperties.text = label
        cellProperties.textProperties.font = .boldSystemFont(ofSize: 20)
        cellProperties.textProperties.color = .black
        cellProperties.secondaryTextProperties.color = .black
        cellProperties.secondaryText = text
        cell.contentConfiguration = cellProperties
        cell.contentView.backgroundColor = .white
        cell.contentView.layer.cornerRadius = 11
        let view = UIView(frame: cell.bounds)
        view.backgroundColor = backgroundCollor
        cell.backgroundView = view //настраиваем задний цвет вьюхи ячейки
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            notesTuplesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    
}


