//
//  ViewController.swift
//  Notes
//
//  Created by Eвгений Павлюков on 03.02.2023.
//

import UIKit

class NotesViewController: UIViewController {
    
    weak var data = Memory.dataTuplesArray
    weak var array =
    
    var refCounter = 0
    let userDefaults = UserDefaults.standard
    
    var notesTableView: UITableView = {
        let notesTableView = UITableView(frame: .zero, style: .grouped)
        notesTableView.translatesAutoresizingMaskIntoConstraints = false
        notesTableView.separatorStyle = .none
        notesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        notesTableView.backgroundColor = backgroundCollor
        return notesTableView
    }()
    
    
    deinit {
        print("NotesVC is destroied")
    }

    override func viewDidLoad() {
        refCounter += 1
        print("ref \(refCounter)")
        super.viewDidLoad()

        let encodedData = try! PropertyListEncoder().encode(Memory.dataTuplesArray)
        UserDefaults.standard.set(encodedData, forKey: "data")
        
        if let fetchedData = userDefaults.data(forKey: "data") {
            let fetchedTuplesArray = try! PropertyListDecoder().decode([Model].self, from: fetchedData) //так как нельзя работать с тюплами в userDefaults кодируем тайтл и текст в дату, сохраняем ее в юзерДелфол, потом при запуске декодим
            Memory.dataTuplesArray = fetchedTuplesArray
            for i in 0 ..< Memory.dataTuplesArray.count {
                let title = Memory.dataTuplesArray[i].title
                let text = Memory.dataTuplesArray[i].text
                let tuple = (title, text)
                Memory.notesTuplesArray.append(tuple)
            }
            print(Memory.dataTuplesArray.count)
            print(Memory.dataTuplesArray)
            print(Memory.notesTuplesArray.count)
            print(Memory.notesTuplesArray)

            if Memory.notesTuplesArray.count > 0 {
                let indexPathNewRow = IndexPath(row: Memory.notesTuplesArray.count - 1, section: 0)
                notesTableView.insertRows(at: [indexPathNewRow], with: .automatic)
                UIRefreshControl().endRefreshing()
                notesTableView.endUpdates()
                
            } else {
                
                Memory.notesTuplesArray.append(("New", "Note"))
                Memory.dataTuplesArray.append(Model(title: "New", text: "Note"))
                
                let indexPathNewRow = IndexPath(row: Memory.notesTuplesArray.count - 1, section: 0)
                notesTableView.insertRows(at: [indexPathNewRow], with: .automatic)
                UIRefreshControl().endRefreshing()
                notesTableView.endUpdates()
            }
            
            print(Memory.dataTuplesArray.count)
            print(Memory.dataTuplesArray)
            print(Memory.notesTuplesArray.count)
            print(Memory.notesTuplesArray)
            
        } else {
            print(Memory.dataTuplesArray.count)
            print(Memory.dataTuplesArray)
            print(Memory.notesTuplesArray.count)
            print(Memory.notesTuplesArray)
        }
        
        view.backgroundColor = backgroundCollor
        notesTableView.delegate = self
        notesTableView.dataSource = self
        view.addSubview(notesTableView)
        navBarSetUp()
        addButtonNote()
        addConstraints()
        notesTableView.endUpdates()
        UIRefreshControl().endRefreshing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let encodedData = try! PropertyListEncoder().encode(Memory.dataTuplesArray)
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
        self.navigationController?.pushViewController(Assembler.createNewNoteVC(), animated: true)
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
    
}


extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Memory.notesTuplesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
              
        let label = Memory.notesTuplesArray[indexPath.row].0
        let text = Memory.notesTuplesArray[indexPath.row].1
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
            Memory.dataTuplesArray.remove(at: indexPath.row)
            Memory.notesTuplesArray.remove(at: indexPath.row)
            
            let encodedData = try! PropertyListEncoder().encode(Memory.dataTuplesArray)
            UserDefaults.standard.set(encodedData, forKey: "data")
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var detailedTitle = Memory.notesTuplesArray[indexPath.row].0
        var detailedText = Memory.notesTuplesArray[indexPath.row].1
        Memory.notesTuplesArray.remove(at: indexPath.row)
        navigationController?.pushViewController(Assembler.createEditNoteVC(), animated: true)
    }
    
}


