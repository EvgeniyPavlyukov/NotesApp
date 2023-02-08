//
//  ViewController.swift
//  Notes
//
//  Created by Eвгений Павлюков on 03.02.2023.
//

import UIKit

class NotesViewController: UIViewController {

    //MARK: - Переменные
    
    let userDefaults = UserDefaults.standard
    var index = 0 //для отслеживания изменений в локальном списке заметок при переходе на другой экран
    
    
    //MARK: - View
    
    var notesTableView: UITableView = {
        let notesTableView = UITableView(frame: .zero, style: .grouped)
        notesTableView.translatesAutoresizingMaskIntoConstraints = false
        notesTableView.separatorStyle = .none
        notesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        notesTableView.backgroundColor = backgroundColor
        notesTableView.layer.cornerRadius = 11
        notesTableView.showsVerticalScrollIndicator = false
        return notesTableView
    }()
    
    
    //MARK: - Цикл экрана
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(Memory.dataTuplesArray)
        
        if index != Memory.dataTuplesArray.count { //если мы перешли на экран и добавили заметку, то список увеличится на одну заметку, поэтому перед показам экрана проверяем эти измениния для корректного добавления ячейки, чтобы не было ошибок
            insertCell()
        }
        
        UIRefreshControl().endRefreshing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.notesTableView.delegate = self
        self.notesTableView.dataSource = self
        
        view.backgroundColor = backgroundColor
        view.addSubview(notesTableView)
        
        navBarSetUp()
        addButtonNote()
        addConstraints()
        
        dataProccess()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveToUserDefaults() //сохраняем данные в UserDefaults
        index = Memory.dataTuplesArray.count //это нужно для того чтобы понять были ли изменения в array после хождения по экранам, если были то нужно добавить ячейки
    }

    
    //MARK: - Functions
    
    func dataProccess() {
        if fetchUserDefaultsData().isEmpty {
            defaultNewNote()
            UIRefreshControl().endRefreshing()
            print("fetched is nil")
            insertCell()
        } else {
            Memory.dataTuplesArray = fetchUserDefaultsData()
            print("fetched successfully")
        }
    }
    
    
    func defaultNewNote() { //если нет заметок, появляется дефолтная заметка
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
    
    func insertCell() {
        let indexPathNewRow = IndexPath(row: Memory.dataTuplesArray.count - 1, section: 0)
        notesTableView.insertRows(at: [indexPathNewRow], with: .automatic)
    }
    

    //MARK: - View set up
    
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
    
    
    //MARK: - Constraints
    
    func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        //constraint for TableView
        constraints.append(notesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20))
        constraints.append(notesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20))
        constraints.append(notesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20))
        constraints.append(notesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)) //make table view anchor to navBar
        
        NSLayoutConstraint.activate(constraints)
    }
    
}



//MARK: - TableView Delegate  /  DataSource

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
        cellProperties.textProperties.numberOfLines = 1
        cellProperties.secondaryTextProperties.numberOfLines = 1
        
        cell.contentConfiguration = cellProperties
        cell.contentView.backgroundColor = .white
        cell.contentView.layer.borderColor = borderCellColor
        cell.contentView.layer.borderWidth = 3
        cell.contentView.layer.cornerRadius = 11
        let view = UIView(frame: cell.bounds)
        view.backgroundColor = backgroundColor
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
            saveToUserDefaults()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}


