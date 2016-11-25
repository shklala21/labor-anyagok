//
//  MessagesViewController.swift
//  Messenger
//

import UIKit

class MessagesViewController: UIViewController, ComposeMessageViewControllerDelegate {

  // MARK: - Outlets

  @IBOutlet weak var tableView: UITableView!

  // MARK: - Properties

  var urlSession: URLSession = {
    let sessionConfiguration = URLSessionConfiguration.default
    return URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: OperationQueue.main)
  }()
  var messages = [Any]()
  var imageCache = [URL: UIImage]()

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ComposeMessageSegue" {
      let vc = segue.destination as? ComposeMessageViewController
      vc?.delegate = self
    }
  }

  // MARK: - ComposeMessageViewControllerDelegate methods

  func composeMessageViewControllerDidSend(_ viewController: ComposeMessageViewController) {
    var message = [String: Any]()
    message["from_user"] = "YOUR NAME"
    message["to_user"] = viewController.toUserTextField.text
    message["topic"] = viewController.topicTextField.text

    if let image = viewController.imageView.image {
      let scaledImage = image.scaleImage(to: CGSize(width: 40, height: 40))
      if let jpegImageData = UIImageJPEGRepresentation(scaledImage, 0.7) {
        message["image"] = jpegImageData.base64EncodedString()
      }
    }

    let jsonData: Data!
    do {
      jsonData = try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
    } catch {
      return
    }

    let url = URL(string: "http://atleast.aut.bme.hu/ait-ios/messenger/add-message")
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    urlSession.uploadTask(with: request, from: jsonData) { data, response, error in
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      if let error = error {
        print("Error during comminication: \(error.localizedDescription).")
        return
      }

      do {
        guard let response = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] else {
          return
        }

        let result = response["result"] as! String

        let alert = UIAlertController(title: "Server response", message: result, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)
      } catch {
        print("Error.")
      }

    }.resume()

  }

  func composeMessageViewControllerDidCancel(_ viewController: ComposeMessageViewController) {
  }

  // MARK: - Actions

  @IBAction func refreshButtonTap(_ sender: AnyObject) {
    let url = URL(string: "http://atleast.aut.bme.hu/ait-ios/messenger/messages")

    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    urlSession.dataTask(with: url!) { data, response, error in
      UIApplication.shared.isNetworkActivityIndicatorVisible = false

      if let error = error {
        print("Error during comminication: \(error.localizedDescription).")
        return
      }

      do {
        guard let messages = try (JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [Any]) else {
          return
        }
        self.messages = messages
        self.tableView.reloadData()
      } catch let parseError as NSError {
        print("Error parsing JSON: \(parseError.localizedDescription)")
      }
    }.resume()
  }

  // MARK: - Helper methods

  func downloadImage(with url: URL, for cell: MessageCell) {
    if let cachedImage = imageCache[url] {
      cell.messageImageView.image = cachedImage
    }
    else {
      cell.messageImageView.image = nil

      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      urlSession.dataTask(with: url) { [weak cell] data, response, error in
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if let data = data, let image = UIImage(data: data) {
          self.imageCache[url] = image
          cell?.messageImageView.image = image
        }
      }.resume()
    }
  }
  
}

// MARK: - Table view data source
extension MessagesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell

    let message = messages[indexPath.row] as! [String: Any]

    let fromUser = message["from_user"] as! String
    let toUser = message["to_user"] as! String
    let topic = message["topic"] as! String

    if let imageURLString = message["imageurl"] as? String {
      downloadImage(with: URL(string: imageURLString)!, for: cell)
    }

    cell.recipientLabel.text = fromUser + " - " + toUser
    cell.subjectLabel.text = topic
    
    return cell
  }
}

// MARK: - Table view delegate
extension MessagesViewController: UITableViewDelegate {

}
