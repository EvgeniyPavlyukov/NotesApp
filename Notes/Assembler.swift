import UIKit

class Assembler {
    
    class func createNotesVC() -> UIViewController {
        var notesVC = NotesViewController()
        
        return notesVC
    }
    
    class func createEditNoteVC() -> UIViewController {
        var editingVC = DetailedViewController()
        
        return editingVC
    }
    
    class func createNewNoteVC() -> UIViewController {
        var newNoteVC = EditingNotesViewController()
        
        return newNoteVC
    }
    
    class func initialVC() -> UINavigationController {
        var rootView = createNotesVC()
        var navigationController = UINavigationController(rootViewController: rootView)
        
        return navigationController
    }
}
