//
//  brickSprite.swift
//  ball_swift
//
//  Created by 荣徽 贺 on 16/4/27.
//  Copyright © 2016年 荣徽 贺. All rights reserved.
//

import SpriteKit

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
    
    func checkContactPos(contactPos: CGPoint) -> Int {
        //let leftX = self.position.x - self.size.width / 2
        //let rightY = self.position.x + self.size.width / 2
        //let contactX = contactPos.x
        let bottomY = self.position.y - self.size.height / 2
        let topY = self.position.y + self.size.height / 2
        let contactY = contactPos.y
        
        if (contactY > topY - 2.0) || (contactY < bottomY + 2.0) {
            return 0;   //碰撞到brick的上下两边
        }else{
            return 1;   //碰撞到brick的左右两边
        }
    }
}
