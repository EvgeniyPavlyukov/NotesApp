//
//  ViewController.swift
//  Notes
//
//  Created by Eвгений Павлюков on 03.02.2023.
//

import UIKit

class NotesViewController: UIViewController {

    let userDefaults = UserDefaults.standard
    var index = 0
    
    var notesTableView: UITableView = {
        let notesTableView = UITableView(frame: .zero, style: .grouped)
        notesTableView.translatesAutoresizingMaskIntoConstraints = false
        notesTableView.separatorStyle = .none
        notesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        notesTableView.backgroundColor = backgroundCollor
        return notesTableView
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(Memory.dataTuplesArray)
        
        if index != Memory.dataTuplesArray.count {
            insertCell()
        }
        
        UIRefreshControl().endRefreshing()
        notesTableView.endUpdates()
        notesTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = backgroundCollor
        self.notesTableView.delegate = self
        self.notesTableView.dataSource = self
        view.addSubview(notesTableView)
        navBarSetUp()
        addButtonNote()
        addConstraints()
        
        
        if fetchUserDefaultsData().isEmpty {
            defaultNewNote()
            UIRefreshControl().endRefreshing()
            print(Memory.dataTuplesArray)
            print("fetched is nil")
            insertCell()
        } else {
            Memory.dataTuplesArray = fetchUserDefaultsData()
            print(fetchUserDefaultsData())
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveToUserDefaults()
        index = Memory.dataTuplesArray.count //это нужно для того чтобы понять были ли изменения в array после хождения по экранам, если были то нужно добавить ячейки
    }
    
    func insertCell() {
        let indexPathNewRow = IndexPath(row: Memory.dataTuplesArray.count - 1, section: 0)
        notesTableView.insertRows(at: [indexPathNewRow], with: .automatic)
    }
    
    func defaultNewNote() {
            Memory.dataTuplesArray.append(Model(title: "New", text: "Note"))
    }
    
    func fetchUserDefaultsData() -> [Model] {
        var fetchedModelArray = [Model]()
        if let fetchedData = self.userDefaults.data(forKey: "data") {
            let fetchedDataArray = try! PropertyListDecoder().decode([Model].self, from: fetchedData) //так как нельзя работать с тюплами в userDefaults кодируем тайтл и текст в дату, сохраняем ее в юзерДелфол, потом при запуске декодим
            fetchedModelArray = fetchedDataArray
        }
        return fetchedModelArray
    }
    
    func saveToUserDefaults() {
        let encodedData = try! PropertyListEncoder().encode(Memory.dataTuplesArray)
        UserDefaults.standard.set(encodedData, forKey: "data")
    }

    func navBarSetUp() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 245/255, green: 185/255, blue: 0/255, alpha: 1)]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        self.title = "Notes"
    }
    
    func addButtonNote() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 245/255, green: 185/255, blue: 0/255, alpha: 1)
        
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
        return Memory.dataTuplesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
              
        let label = Memory.dataTuplesArray[indexPath.row].title
        let text = Memory.dataTuplesArray[indexPath.row].text
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
            
            let encodedData = try! PropertyListEncoder().encode(Memory.dataTuplesArray)
            UserDefaults.standard.set(encodedData, forKey: "data")
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Memory.detailedTitle = Memory.dataTuplesArray[indexPath.row].title
        Memory.detailedText = Memory.dataTuplesArray[indexPath.row].text
        Memory.indexCell = indexPath.row
        navigationController?.pushViewController(Assembler.createEditNoteVC(), animated: true)
    }
    
}


