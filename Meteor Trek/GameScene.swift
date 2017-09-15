//
//  GameScene.swift
//  Meteor Trek
//
//  Created by Alisher Abdukarimov on 9/14/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var tracksArray: [SKSpriteNode]? = [SKSpriteNode]()
    var player: SKSpriteNode?
    var target: SKSpriteNode?
    
    var currentTrack = 0
    var movingToTrack = false
    
    let trackVelocity = [180, 200, 250]
    var directionArray = [Bool]()
    var velocityArray = [Int]()
    
    
    let playerCategory: UInt32   = 0x1 << 0
    let enemyCategory: UInt32    = 0x1 << 1
    let targetCategory: UInt32   = 0x1 << 2
    
    
    let moveSound = SKAction.playSoundFileNamed("move.wav", waitForCompletion: false)
    
    
    override func didMove(to view: SKView) {
        setupTracks()
        createPlayer()
        createTarget()
        
        self.physicsWorld.contactDelegate = self
        
        runSpawnEnemmyFunction()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var playerBody: SKPhysicsBody
        var otherBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            playerBody = contact.bodyA
            otherBody = contact.bodyB
        } else {
            playerBody = contact.bodyB
            otherBody = contact.bodyA
        }
        
        if playerBody.categoryBitMask == playerCategory && otherBody.categoryBitMask == enemyCategory {
            print("Hit Enemy")
        } else if playerBody.categoryBitMask == playerCategory && otherBody.categoryBitMask == targetCategory {
            print("Hit Target")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
            if node?.name == "right" {
                self.moveHorizontally(right: true)
            } else if node?.name == "up" {
                self.moveToNextTrack()
            } else if node?.name == "left" {
                self.moveHorizontally(right: false)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !movingToTrack {
           player?.removeAllActions()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        player?.removeAllActions()
    }
}
