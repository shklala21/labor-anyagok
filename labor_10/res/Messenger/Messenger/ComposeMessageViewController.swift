//
//  ComposeMessageViewController.swift
//  Messenger
//
//  Copyright © 2017. BME AUT. All rights reserved.
//

import UIKit

protocol ComposeMessageViewControllerDelegate: class {
    // Called when the user presses the Send button to issue sending the message
    func composeMessageViewControllerDidSend(_ viewController: ComposeMessageViewController)
    
}

class ComposeMessageViewController: UITableViewController {

    // MARK: - Properties
    
    weak var delegate: ComposeMessageViewControllerDelegate?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHelpLabel: UILabel!
    @IBOutlet weak var recipientTextField: UITextField!
    @IBOutlet weak var topicTextField: UITextField!

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Actions
    
    @IBAction func sendButtonTap(_ sender: Any) {
        delegate?.composeMessageViewControllerDidSend(self)
    }
    
    @IBAction func imageViewTap(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func textFieldDidEndOnExit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
}

// MARK: - UIImagePickerControllerDelegate

extension ComposeMessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageViewHelpLabel.isHidden = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
