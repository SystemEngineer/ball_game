//
//  GameScene.swift
//  ball_swift
//
//  Created by 荣徽 贺 on 16/4/17.
//  Copyright (c) 2016年 荣徽 贺. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let Ball: UInt32 = 0b0
    static let TopBorder: UInt32 = 0b1
    static let LeftBorder: UInt32 = 0b10
    static let RightBorder: UInt32 = 0b100
    static let BottomBorder: UInt32 = 0b1000
    static let Brick: UInt32 = 0b10000
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let ballSprite = BallSprite(color: UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0), size: CGSize(width: 10.0, height: 10.0))
    var ballVelX = CGFloat(0.0)
    var ballVelY = CGFloat(0.0)
    var sceneBorderHelper = BorderHelper()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        /*
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
        */
        //self.scaleMode = SKSceneScaleMode.AspectFill
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self
        
        //==>SpriteKit的坐标系统是如何定义的??左下角为(0, 0)
        print("frame rect size is \(self.frame.size.width), \(self.frame.size.height), origin pos is \(self.frame.origin.x), \(self.frame.origin.y)")
        
        // 创建四条边界
        let borderWidth = CGFloat(60.0)
        self.sceneBorderHelper.createBorder(self.frame, borderWidth: borderWidth)
        self.sceneBorderHelper.addBorderToScene(self)
        
        //创建待摧毁的方块
        let brickSize = CGSize(width:(self.frame.width - 2 * borderWidth) / 5, height: 20.0)
        let rowsOfBrick = Int(CGRectGetMidY(self.frame) / brickSize.height) - 1
        let colsOfBrick = Int((self.frame.width - 2 * borderWidth) / brickSize.width) - 1
        print("There are \(rowsOfBrick) rows & \(colsOfBrick) columns")
        for row in 0 ... rowsOfBrick {
            for col in 0 ... colsOfBrick {
                let brickSprite = BrickSprite(color: UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0), size: brickSize)
                brickSprite.position = CGPoint(x: borderWidth + brickSize.width / 2 + CGFloat(col) * brickSize.width, y: CGRectGetMidY(self.frame) + CGFloat(row) * brickSize.height)
                self.addChild(brickSprite)
            }
        }

        print("ball size rect size is (\(ballSprite.size.width), \(ballSprite.size.height))")
        ballSprite.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - 100)
        self.addChild(ballSprite)
        
    }
    
    func didBeginContact(contact:SKPhysicsContact){
        var secondBody = contact.bodyB
        if(contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask){
            secondBody = contact.bodyA
        }
        print("second contact body cata \(secondBody.categoryBitMask), collision pos is \(contact.contactPoint))")
        //==>由于spritekit的bug, 反弹可能因为作用力太小而导致某个方向的速度为0(弹不起来),因此每次碰撞的时候设置球的速度
        switch secondBody.categoryBitMask{
        case PhysicsCategory.TopBorder, PhysicsCategory.BottomBorder:
            ballVelY = -ballVelY
            ballSprite.physicsBody?.velocity = CGVectorMake(ballVelX, ballVelY)
        case PhysicsCategory.LeftBorder, PhysicsCategory.RightBorder:
            ballVelX = -ballVelX
            ballSprite.physicsBody?.velocity = CGVectorMake(ballVelX, ballVelY)
        case PhysicsCategory.Brick:
            //==>判断撞击在brick的哪一测,并从场景中移除该brick节点
            if let brickSprite = secondBody.node as? BrickSprite {
                switch brickSprite.checkContactPos(contact.contactPoint) {
                //==>加入对速度方向的判断,避免同时碰到两个brick交接点时, 速度变化两次
                case sideOfBrick.Left:
                    if ballVelX > 0 {
                        ballVelX = -ballVelX
                    }
                    ballSprite.physicsBody?.velocity = CGVectorMake(ballVelX, ballVelY)
                case sideOfBrick.Right:
                    if ballVelX < 0 {
                        ballVelX = -ballVelX
                    }
                    ballSprite.physicsBody?.velocity = CGVectorMake(ballVelX, ballVelY)
                case sideOfBrick.Top:
                    if ballVelY < 0 {
                        ballVelY = -ballVelY
                    }
                    ballSprite.physicsBody?.velocity = CGVectorMake(ballVelX, ballVelY)
                case sideOfBrick.Bottom:
                    if ballVelY > 0 {
                        ballVelY = -ballVelY
                    }
                    ballSprite.physicsBody?.velocity = CGVectorMake(ballVelX, ballVelY)
                }
                print("remove brick at position (\(brickSprite.position.x), \(brickSprite.position.y))")
                brickSprite.removeFromParent()
            }
        default:
            print("Error contact with secondBody cate is \(secondBody.categoryBitMask)")
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        //ballSprite.physicsBody?.velocity = CGVectorMake(280, 66)
        if (ballVelX == 0) && (ballVelY == 0) {
            ballSprite.physicsBody?.applyImpulse(CGVectorMake(-11, 3))
            ballVelX = (ballSprite.physicsBody?.velocity.dx)!
            ballVelY = (ballSprite.physicsBody?.velocity.dy)!
        }else{
            ballVelY = CGFloat(0.0)
            ballVelX = CGFloat(0.0)
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
