//
//  Protocols.swift
//  Notes
//
//  Created by Eвгений Павлюков on 07.02.2023.
//

import Foundation

protocol ViewInput: AnyObject {
    func updateViewNewNote(title: String, text: String)
    func updateViewEditNote(title: String, text: String)
}

protocol ViewOutput: AnyObject {
    func sendToDetailView(title: String, text: String)
    func saveNewNote(title: String, text: String)
    func saveEditNote(title: String, text: String)
}

protocol DetailViewInput: AnyObject {
    func updateDetailView(title: String, text: String)
}

class NotesPresenter: ViewOutput {
    
    var output = Assembler.initialVC().viewControllers.first
    
    func saveNewNote(title: String, text: String) {
        output.updateViewNewNote(title: title, text: text)
    }
        
    func saveEditNote(title: String, text: String) {
        output.updateViewEditNote(title: title, text: text)
    }
    
    func sendToDetailView(title: String, text: String) {
        NotesViewController().navigationController?.pushViewController(Assembler.createNewNoteVC(), animated: true)
        
    }
    
    func updateDetailView(title: String, text: String) {
        
    }
        
    
}
