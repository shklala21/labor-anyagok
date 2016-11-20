//
//  MessagesViewController.swift
//  Messenger
//

import UIKit

class MessagesViewController: UITableViewController {

  // MARK: - Properties

  // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell

    // Configure cell...

    return cell
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ComposeMessageSegue" {
      let vc = segue.destination as? ComposeMessageViewController
      vc?.delegate = self
    }
  }

  // MARK: - Actions

  @IBAction func refreshButtonTap(_ sender: AnyObject) {
  }

  // MARK: - Helper methods

  func downloadImage(with url: URL, for cell: MessageCell) {
  }
  
}

// MARK: - ComposeMessageViewControllerDelegate
extension MessagesViewController: ComposeMessageViewControllerDelegate {

  func composeMessageViewControllerDidSend(_ viewController: ComposeMessageViewController) {
  }

  func composeMessageViewControllerDidCancel(_ viewController: ComposeMessageViewController) {
  }

}
