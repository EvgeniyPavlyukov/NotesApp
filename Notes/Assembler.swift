import UIKit

class Assembler {
    
    class func createNotesVC() -> UIViewController {
        let notesVC = NotesViewController()
        
        return notesVC
    }
    
    class func createEditNoteVC() -> UIViewController {
        let editingVC = DetailedViewController()
        
        return editingVC
    }
    
    class func createNewNoteVC() -> UIViewController {
        let newNoteVC = NewNotesViewController()
        
        return newNoteVC
    }

}
