//
//  Assembler.swift
//  Notes
//
//  Created by Eвгений Павлюков on 07.02.2023.
//

import UIKit

class Assembler {
    
    class func createNotesVC() -> UIViewController {
        let notesVC = NotesViewController()
        let presenter = NotesPresenter()
        
        presenter.output = notesVC
        notesVC.output = presenter
        
        return notesVC
    }
    
    class func createEditNoteVC() -> UIViewController {
        let editingVC = EditingNotesViewController()
        let presenter = NotesPresenter()
        let notesVC = NotesViewController()
        
        presenter.output = notesVC
        editingVC.output = presenter
        
        return editingVC
    }
    
    class func createNewNoteVC() -> UIViewController {
        let newNoteVC = NewNotesViewController()
        let presenter = NotesPresenter()
        let notesVC = NotesViewController()
    
        newNoteVC.output = presenter
        presenter.output = notesVC
        
        return newNoteVC
    }
    
    class func initialVC() -> UINavigationController {
        let rootView = createNotesVC()
        let navigationController = UINavigationController(rootViewController: rootView)
        
        return navigationController
    }
}
