//
//  GameElements.swift
//  Meteor Trek
//
//  Created by Alisher Abdukarimov on 9/15/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    
    // Mark CreatePlayerMethod
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        guard let playerPosition = tracksArray?.first?.position.y else { return }
        player?.size = CGSize(width: 60, height: 60)
        player?.position = CGPoint(x: self.size.width / 2, y: playerPosition)
        player?.physicsBody = SKPhysicsBody(circleOfRadius: player!.size.width / 2)
        player?.physicsBody?.linearDamping = 0
        player?.physicsBody?.categoryBitMask = playerCategory
        player?.physicsBody?.collisionBitMask = 0
        player?.physicsBody?.contactTestBitMask = enemyCategory | targetCategory
        
        self.addChild(player!)
        
        let pulse = SKEmitterNode(fileNamed: "Pulse")!
        player?.addChild(pulse)
        pulse.position = CGPoint(x: 0, y: 0)
    }
    
    func createTarget() {
        target = self.childNode(withName: "target") as? SKSpriteNode
        target?.physicsBody = SKPhysicsBody(circleOfRadius: target!.size.width / 2)
        target?.physicsBody?.categoryBitMask = targetCategory
    }
    
    // Mark:
    func createEnemy(enemy: Enemies, forTrack track: Int) -> SKShapeNode? {
        let enemySprite = SKShapeNode()
        
        switch enemy {
        case .small:
            enemySprite.path = CGPath(roundedRect: CGRect(x: 0, y: -10, width: 100, height: 20) , cornerWidth: 10, cornerHeight: 10, transform: nil)
            enemySprite.fillColor = UIColor(red: 0.4431, green: 0.5529, blue: 0.7451, alpha: 1)
        case .medium:
            enemySprite.path = CGPath(roundedRect: CGRect(x: 0, y: -10, width: 140, height: 20) , cornerWidth: 10, cornerHeight: 10, transform: nil)
            enemySprite.fillColor = UIColor(red: 0.7804, green: 0.4039, blue: 0.4039, alpha: 1)
        case .large:
            enemySprite.path = CGPath(roundedRect: CGRect(x: 0, y: -10, width: 160, height: 20) , cornerWidth: 10, cornerHeight: 10, transform: nil)
            enemySprite.fillColor = UIColor(red: 0.4431, green: 0.5529, blue: 0.7451, alpha: 1)
        }
        
        guard let enemyPositon = tracksArray?[track].position else {
            return nil
        }
        
        let up = directionArray[track]
        
        enemySprite.position.y = enemyPositon.y
        enemySprite.position.x = up ? -130 : self.size.width + 130
        enemySprite.name = "enemy"
        enemySprite.physicsBody = SKPhysicsBody(edgeLoopFrom: enemySprite.path!)
        enemySprite.physicsBody?.velocity = up ? CGVector(dx: velocityArray[track], dy: 0) : CGVector(dx: -velocityArray[track], dy: 0)
        enemySprite.physicsBody?.categoryBitMask = enemyCategory
        
        return enemySprite
    }
    
    func setupTracks() {
        for i in 0...9 {
            if let track = self.childNode(withName: "\(i)") as? SKSpriteNode {
                tracksArray?.append(track)
            }
        }
        tracksArray?.first?.color = UIColor.green
    }
}
