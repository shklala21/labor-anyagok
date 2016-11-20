//
//  ComposeMessageViewController.swift
//  Messenger
//

import UIKit

protocol ComposeMessageViewControllerDelegate{
  // Called when the user presses the Send button to issue sending the message
  func composeMessageViewControllerDidSend(_ viewController: ComposeMessageViewController)

  // Called when the user presses the Cancel button to cancel the message composer
  func composeMessageViewControllerDidCancel(_ viewController: ComposeMessageViewController)
}

class ComposeMessageViewController: UITableViewController, UINavigationControllerDelegate {

  // MARK: - Properties

  var delegate: ComposeMessageViewControllerDelegate?

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var toUserTextField: UITextField!
  @IBOutlet weak var topicTextField: UITextField!

  // MARK: - UIScrollViewDelegate

  override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    // Hide the keyboard when the table view is scrolled
    view.endEditing(true)
  }

  // MARK: - Actions

  @IBAction func cancelButtonTap(_ sender: AnyObject) {
    delegate?.composeMessageViewControllerDidCancel(self)
    _ = navigationController?.popViewController(animated: true)
  }

  @IBAction func sendButtonTap(_ sender: AnyObject) {
    delegate?.composeMessageViewControllerDidSend(self)
    _ = navigationController?.popViewController(animated: true)
  }

  @IBAction func imageViewTap(_ sender: AnyObject) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .savedPhotosAlbum
    present(imagePicker, animated: true, completion: nil)
  }

  @IBAction func textFieldDidEndOnExit(_ sender: AnyObject) {
    _ = sender.resignFirstResponder()
  }

}

// MARK: - UITextViewDelegate
extension ComposeMessageViewController: UITextViewDelegate {

  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

    // Hide the keyboard when the user presses the return key
    if text == "\n" {
      textView.resignFirstResponder()
      return false
    }

    return true
  }

}

// MARK: - UIImagePickerControllerDelegate
extension ComposeMessageViewController: UIImagePickerControllerDelegate {

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      imageView.image = image
      imageView.backgroundColor = UIColor.white
    }

    dismiss(animated: true, completion: nil)
  }

}
