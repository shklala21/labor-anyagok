//: Playground - noun: a place where people can play

import UIKit

protocol Fightable {
  var name: String { get }
  var isDead: Bool { get }
  var power: Int { get }
  func takeDamage(from enemy: Fightable)
}

func fight(fighter1: Fightable, fighter2: Fightable) -> Fightable? {

  while !fighter1.isDead && !fighter2.isDead {
    fighter1.takeDamage(from: fighter2)
    fighter2.takeDamage(from: fighter1)
  }

  if !fighter1.isDead {
    return fighter1
  }

  if !fighter2.isDead {
    return fighter2
  }

  return nil
}

class GameCharacter: NSObject {
  var name: String
  var level: Int
  var hitPoints = 100

  init?(name: String, level: Int) {
    if level < 0 || level >= 100 {
      return nil
    }

    self.name = name
    self.level = level

    super.init()
  }
}

extension GameCharacter: Fightable {
  var isDead: Bool {
    return hitPoints <= 0
  }
  var power: Int {
    return level * 10
  }

  func takeDamage(from enemy: Fightable) {
    let attackRating = Double(arc4random_uniform(10) + 1) / 10
    hitPoints -= Int(Double(enemy.power) * attackRating)
  }
}

class Hero: GameCharacter {

  enum  WeaponType {
    case LaserCannon
    case Spoon
  }

  var weapon: WeaponType?

  override var power: Int {
    var extraPower = 0
    if weapon != nil {
      switch weapon! {
      case .LaserCannon:
        extraPower = 100
      case .Spoon:
        extraPower = 1
      }
    }
    return super.power + extraPower
  }
}

class Monster {
  var name: String
  var headCount: Int

  init(name: String, headCount: Int) {
    self.name = name
    self.headCount = headCount
  }
}

extension Monster: Fightable {
  var isDead: Bool {
    return headCount < 1
  }
  var power: Int {
    return headCount * 20
  }

  func takeDamage(from enemy: Fightable) {
    if Int(arc4random_uniform(UInt32(power / 10))) > 0 {
      headCount -= 1
    }
  }
}

let monster1 = Monster(name: "1", headCount: 2)
let monster2 = Monster(name: "2", headCount: 10)

let monster3 = Monster(name: "3", headCount: 2)
let hero1 = Hero(name: "Varázsló Vilmos", level: 10)
hero1?.weapon = .LaserCannon

let winner = fight(fighter1: hero1!, fighter2: monster3)
if winner != nil {
  print("The winner of this vicious fight is: \(winner!.name)")
}
else {
  print("Both monsters died in this cruel fight.")
}
