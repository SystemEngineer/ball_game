//
//  BouncerSprite.swift
//  ball_swift
//
//  Created by 荣徽 贺 on 16/6/4.
//  Copyright © 2016年 荣徽 贺. All rights reserved.
//

import SpriteKit

class BouncerSprite: SKSpriteNode {
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        print("bouncer init")
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Bouncer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}