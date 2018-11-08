//
//  Message.swift
//  Messenger
//
//  Copyright © 2017. BME AUT. All rights reserved.
//

import Foundation

struct Message: Codable {
  
  let sender: String
  let recipient: String
  let topic: String
  var image: String?
  let imageUrl: String?
  
  init(sender: String, recipient: String, topic: String) {
    self.sender = sender
    self.recipient = recipient
    self.topic = topic
    imageUrl = nil
  }
  
  enum CodingKeys: String, CodingKey {
    case sender = "from_user"
    case recipient = "to_user"
    case topic
    case image
    case imageUrl = "imageurl"
  }
  
}
