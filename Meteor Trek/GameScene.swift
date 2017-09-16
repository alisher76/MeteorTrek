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
    
    // MARK: Nodes
    var player: SKSpriteNode?
    var target: SKSpriteNode?
    
    
    // MARK: HUD??
    
    
    // MARK: Arrays
    var tracksArray: [SKSpriteNode]? = [SKSpriteNode]()
    let trackVelocity = [180, 200, 250]
    var directionArray = [Bool]()
    var velocityArray = [Int]()
    
    let playerCategory: UInt32   = 0x1 << 0
    let enemyCategory: UInt32    = 0x1 << 1
    let targetCategory: UInt32   = 0x1 << 2
    
    // MARK: Sounds
    let moveSound = SKAction.playSoundFileNamed("move.wav", waitForCompletion: false)

    // MARK: Rest of the Variables
    var currentTrack = 0
    var movingToTrack = false
    
    
    // MARK: Game Entry Point
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
            movePlayerToStart()
        } else if playerBody.categoryBitMask == playerCategory && otherBody.categoryBitMask == targetCategory {
            print("Hit Target")
            nextLevel(playerPhysicsBody: playerBody)
        }
    }
    
    // MARK: Touche Control
    
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
    
    // MARK: Update
    
    // Called before each frame rendered
    override func update(_ currentTime: TimeInterval) {
        if let player = self.player {
            if player.position.x > self.size.width || player.position.x < 0 {
                movePlayerToStart()
            }
        }
    }
    
    func nextLevel(playerPhysicsBody: SKPhysicsBody) {
    //    let emitter = SKEmitterNode(fileNamed: "Fireworks.sks")
   //     playerPhysicsBody.node?.addChild(emitter!)
   //     self.run(SKAction.wait(forDuration: 0.5)) {
           // emitter!.removeFromParent()
            self.movePlayerToStart()
   //     }
    }
}
