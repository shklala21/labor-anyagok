//
//  MessagesViewController.swift
//  Messenger
//
//  Copyright © 2017. BME AUT. All rights reserved.
//

import UIKit

class MessagesViewController: UITableViewController {
  
  // MARK: - Properties
  
  private var messages = [Message]()
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
    
    let message = messages[indexPath.row]
    
    cell.recipientLabel.text = "\(message.sender) -> \(message.recipient)"
    cell.topicLabel.text = message.topic
    
    if let imageUrlString = message.imageUrl, let imageUrl = URL(string: imageUrlString) {
      NetworkHelper.downloadImage(with: imageUrl) { image in
        cell.messageImageView.image = image
      }
    }
    
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
  
  @IBAction func refreshButtonTap(_ sender: Any) {
    NetworkHelper.downloadMessages { messages in
      self.messages = messages
      self.tableView.reloadData()
    }
  }
  
}

// MARK: - ComposeMessageViewControllerDelegate

extension MessagesViewController: ComposeMessageViewControllerDelegate {
  
  func composeMessageViewControllerDidSend(_ viewController: ComposeMessageViewController) {
    navigationController?.popToRootViewController(animated: true)
    
    guard let recipient = viewController.recipientTextField.text, let topic = viewController.topicTextField.text else { return }
    
    var message = Message(sender: "YOUR NAME", recipient: recipient, topic: topic)
    if let image = viewController.imageView.image, let jpegImageData = UIImageJPEGRepresentation(image.scale(to: CGSize(width: 40, height: 40)), 0.7) {
      message.image = jpegImageData.base64EncodedString()
    }
    
    let encoder = JSONEncoder()
    
    guard let jsonData = try? encoder.encode(message) else { return }
    
    NetworkHelper.uploadMessage(jsonData: jsonData) { alert in
      self.present(alert, animated: true, completion: nil)
    }
  }
  
}
