//
//  PostsTableViewController.swift
//  Posts
//
//  Created by Luis Sergio Duran Arenas on 12/10/23.
//

import UIKit

class PostsTableViewController: UITableViewController {
    
    @IBOutlet var emptyNoteView: UIView!
    
    let postService = NoteManager()
    
    var note: Note?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteManager.loadNotes()
        
        updateEmptyView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteManager.countNotes()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        
        let note = noteManager.getNote(at: indexPath.row)
        
        cell.textLabel?.text = note.title
        
        cell.detailTextLabel?.text = note.date.iso8601String
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            noteManager.deleteNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            noteManager.saveNotes()
            
            updateEmptyView()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //perform segue when user touches a cell
        performSegue(withIdentifier: "showNoteSegue", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showNoteSegue" {
            let destination = segue.destination as! AddPostViewController
            destination.note = noteManager.getNote(at: self.tableView.indexPathForSelectedRow!.row)
            destination.newNoteFlag = false
        }
    }
    
    @IBAction func unwindFromAddNoteViewController(segue: UIStoryboardSegue) {
        print("Unwind segue!")
        
        let source = segue.source as! AddPostViewController
        
        note = source.note
        
        if source.newNoteFlag {
            noteManager.createNote(note: note!)
        } else {
            noteManager.updateNote(note: note!, at: self.tableView.indexPathForSelectedRow!.row)
        }
        
        print("# notas: ", noteManager.countNotes())
        
        // print("notas: ", noteManager.getNotes())
        
        noteManager.saveNotes()
        
        self.tableView.reloadData()
        
        updateEmptyView()
        
    }
    
    func updateEmptyView() {
        if noteManager.countNotes() == 0 {
            
            emptyNoteView.isHidden = false
            
            self.tableView.backgroundView = emptyNoteView
            
        } else {
            
            emptyNoteView.isHidden = true
            
        }
    }

}
