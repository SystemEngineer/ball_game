//
//  brickSprite.swift
//  ball_swift
//
//  Created by 荣徽 贺 on 16/4/27.
//  Copyright © 2016年 荣徽 贺. All rights reserved.
//

import SpriteKit

enum sideOfBrick {
    case Top
    case Bottom
    case Left
    case Right
}

class BrickSprite: SKSpriteNode {
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Brick
    }
    
    //==>子类没有实现父类的这一构造器,因此要在这里加上
    //==>swift类的构造器需要了解一下:指定构造器和便利构造器(convenience修饰符)
    //==>以及public修饰符的作用
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkContactPos(contactPos: CGPoint) -> sideOfBrick {
        let leftX = self.position.x - self.size.width / 2
        _ = self.position.x + self.size.width / 2
        let contactX = contactPos.x
        let bottomY = self.position.y - self.size.height / 2
        let topY = self.position.y + self.size.height / 2
        let contactY = contactPos.y
        
        if (contactY > topY - 1.0) {
            //print("touch the top")
            return sideOfBrick.Top   //碰撞到brick的上下两边
        }else if (contactY < bottomY + 1.0) {
            //print("touch the bottom")
            return sideOfBrick.Bottom
        }else if (contactX < leftX + 1.0) {
            //print("touch the left")
            return sideOfBrick.Left   //碰撞到brick的左右两边
        }else {
            //print("touch the right")
            return sideOfBrick.Right
        }
    }
}
