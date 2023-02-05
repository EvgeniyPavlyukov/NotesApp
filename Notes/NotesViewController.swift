//
//  ViewController.swift
//  Notes
//
//  Created by Eвгений Павлюков on 03.02.2023.
//

import UIKit

class NotesViewController: UIViewController, EditingNotesDelegate {
    
    var dataTuplesArray = [Model]()
    var notesTuplesArray = [(String, String)]()
    var editingVC = EditingNotesViewController()
    
    let userDefaults = UserDefaults.standard
    
    var notesTableView: UITableView = {
        let notesTableView = UITableView(frame: .zero, style: .grouped)
        notesTableView.translatesAutoresizingMaskIntoConstraints = false
        notesTableView.separatorStyle = .none
        notesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        notesTableView.backgroundColor = backgroundCollor
        return notesTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let fetchedData = userDefaults.data(forKey: "data") {
            let fetchedTuplesArray = try! PropertyListDecoder().decode([Model].self, from: fetchedData) //так как нельзя работать с тюплами в userDefaults кодируем тайтл и текст в дату, сохраняем ее в юзерДелфол, потом при запуске декодим
            dataTuplesArray = fetchedTuplesArray
            for i in 0..<dataTuplesArray.count {
                let title = dataTuplesArray[i].title
                let text = dataTuplesArray[i].text
                let tuple = (title, text)
                notesTuplesArray.append(tuple)
            }
            print(dataTuplesArray)
            
        } else {
            notesTuplesArray.append(("New Note", "New Text"))
        }
        
        view.backgroundColor = backgroundCollor
        self.editingVC.delegate = self
        notesTableView.delegate = self
        notesTableView.dataSource = self
        view.addSubview(notesTableView)
        navBarSetUp()
        addButtonNote()
        addConstraints()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let encodedData = try! PropertyListEncoder().encode(dataTuplesArray)
        UserDefaults.standard.set(encodedData, forKey: "data")
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
        
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: - Delegate
    
    func obtainNewNoteData(title: String, text: String) {
        
        let notesTuple = (title, text)
        notesTuplesArray.append(notesTuple)
        
        dataTuplesArray.append(Model(title: title, text: text))
        
        
        
//        let savedData = userDefaults.set
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
            dataTuplesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    
}


