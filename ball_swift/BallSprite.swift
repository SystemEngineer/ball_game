//
//  ballSprite.swift
//  ball_swift
//
//  Created by 荣徽 贺 on 16/4/29.
//  Copyright © 2016年 荣徽 贺. All rights reserved.
//

import SpriteKit

class BallSprite: SKSpriteNode {
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        //==>物理刚体的大小不能是ballSprite的大小, Why??
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.size.width + 1, height: self.size.height + 1))
        //==>物理刚体属性
        self.physicsBody?.mass = 0.03
        self.physicsBody?.friction = 0.0
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.angularDamping = 0.0
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.allowsRotation = false
        //==>场景初始化代码里施加力是不起作用的, 所以加到了touchesBegan里
        //ballSprite.physicsBody?.applyForce(CGVectorMake(-75, 75))
        self.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        //==>添加撞击检测, 必须添加以后才会触发碰撞事件!
        self.physicsBody?.contactTestBitMask = PhysicsCategory.BottomBorder | PhysicsCategory.TopBorder | PhysicsCategory.LeftBorder | PhysicsCategory.RightBorder | PhysicsCategory.Brick | PhysicsCategory.Bouncer

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reverseVelX() {
        self.physicsBody?.velocity = CGVectorMake(-(self.physicsBody?.velocity.dx)!, (self.physicsBody?.velocity.dy)!)
    }
    
    func reverseVelY() {
        self.physicsBody?.velocity = CGVectorMake((self.physicsBody?.velocity.dx)!, -(self.physicsBody?.velocity.dy)!)
    }
}
