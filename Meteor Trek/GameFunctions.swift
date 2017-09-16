//
//  GameFunctions.swift
//  Meteor Trek
//
//  Created by Alisher Abdukarimov on 9/15/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//


import SpriteKit
import GameplayKit

extension GameScene {
    
    
    func spawnEnemy() {
        for i in 1...8 {
            let randomEnemyType = Enemies(rawValue: GKRandomSource.sharedRandom().nextInt(upperBound: 3))!
            if let newEnemy = createEnemy(enemy: randomEnemyType, forTrack: i) {
                self.addChild(newEnemy)
            }
        }
        
        self.enumerateChildNodes(withName: "enemy") { (node, nil) in
            if node.position.x < -150 || node.position.x > self.size.width + 150 {
                node.removeFromParent()
            }
        }
    }
    
    func runSpawnEnemmyFunction() {
        if let numberOdTracks = tracksArray?.count {
            for _ in 0 ... numberOdTracks {
                let randomNumberForVelocity = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
                velocityArray.append(trackVelocity[randomNumberForVelocity])
                directionArray.append(GKRandomSource.sharedRandom().nextBool())
            }
        }
        
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            self.spawnEnemy()
            }, SKAction.wait(forDuration: 2)])))
    }
    
    func moveHorizontally(right: Bool) {
        if right {
            let moveAction = SKAction.moveBy(x: 2, y: 0, duration: 0.01)
            let repeatAction = SKAction.repeatForever(moveAction)
            player?.run(repeatAction)
        } else {
            let moveAction = SKAction.moveBy(x: -2, y: 0, duration: 0.01)
            let repeatAction = SKAction.repeatForever(moveAction)
            player?.run(repeatAction)
        }
    }
    
    func moveToNextTrack() {
        player?.removeAllActions()
        movingToTrack = true
        
        guard let nextTrack = tracksArray?[currentTrack + 1].position else { return }
        
        if let player = self.player {
            let moveAction = SKAction.move(to: CGPoint(x: player.position.x, y: nextTrack.y) , duration: 0.2)
            
            let up = directionArray[currentTrack + 1]
            
            player.run(moveAction, completion: {
                self.movingToTrack = false
                if self.currentTrack != 9 {
                 self.player?.physicsBody?.velocity = up ? CGVector(dx: self.velocityArray[self.currentTrack], dy: 0) : CGVector(dx: -self.velocityArray[self.currentTrack], dy: 0)
                } else {
                 self.player?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                }
                
            })
            currentTrack += 1
            
            self.run(moveSound)
        }
    }
    
    func movePlayerToStart() {
        if let player = self.player {
            player.removeFromParent()
            self.player = nil
            self.createPlayer()
            self.currentTrack = 0
        }
    }
}

