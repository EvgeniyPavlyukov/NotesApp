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
        let newNoteVC = EditingNotesViewController()
        
        return newNoteVC
    }
    
    class func initialVC() -> UINavigationController {
        let rootView = createNotesVC()
        let navigationController = UINavigationController(rootViewController: rootView)
        
        return navigationController
    }
}
