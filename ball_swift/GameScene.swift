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
    static let Bouncer: UInt32 = 0b100000
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let ballSprite = BallSprite(imageNamed: "Ball")
    let bouncerSprite = BouncerSprite(color: UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0),
                                      size: CGSize(width:100, height: 5.0))
    var ballVelX = CGFloat(0.0)
    var ballVelY = CGFloat(0.0)
    var sceneBorderHelper = BorderHelper()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //self.scaleMode = SKSceneScaleMode.AspectFill
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self
        
        //==>SpriteKit的坐标系统是如何定义的??左下角为(0, 0)
        print("frame rect size is \(self.frame.size.width), \(self.frame.size.height), origin pos is \(self.frame.origin.x), \(self.frame.origin.y)")
        
        // 创建四条边界
        let borderWidth = CGFloat(1.0)
        self.sceneBorderHelper.createBorder(self.frame, borderWidth: borderWidth)
        self.sceneBorderHelper.addBorderToScene(self)
        
        // 创建待摧毁的方块
        let bricksPerRow = CGFloat(5)
        let brickSize = CGSize(width:(self.frame.width - 2 * borderWidth) / bricksPerRow, height: 20.0)
        let rowsOfBrick = Int(CGRectGetMidY(self.frame) / (2 * brickSize.height)) - 1
        let colsOfBrick = Int((self.frame.width - 2 * borderWidth) / brickSize.width) - 1
        print("There are \(rowsOfBrick) rows & \(colsOfBrick) columns, brick width is \(brickSize.width)")
        for row in 0 ... rowsOfBrick {
            for col in 0 ... colsOfBrick {
                let brickSprite = BrickSprite(texture: SKTexture(imageNamed: "Brick"), color: UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0), size: brickSize)
                brickSprite.position = CGPoint(x: borderWidth + brickSize.width / 2 + CGFloat(col) * brickSize.width, y: self.frame.height - (1.0 + CGFloat(row)) * brickSize.height)
                self.addChild(brickSprite)
            }
        }
        
        // 创建挡板
        bouncerSprite.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMinY(self.frame) + 50)
        self.addChild(bouncerSprite)
        
        // 放置球体, 将球体放在挡板上
        print("ball size rect size is (\(ballSprite.size.width), \(ballSprite.size.height))")
        ballSprite.position = CGPoint(x: bouncerSprite.position.x, y: bouncerSprite.position.y + ballSprite.size.height)
        self.addChild(ballSprite)
        
        //
        self.createLayoutByGameLevelsCfg()
    }
    
    func didBeginContact(contact:SKPhysicsContact){
        var secondBody = contact.bodyB
        if(contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask){
            secondBody = contact.bodyA
        }
        //print("second contact body cata \(secondBody.categoryBitMask), collision pos is \(contact.contactPoint))")
        //==>由于spritekit的bug, 反弹可能因为作用力太小而导致某个方向的速度为0(弹不起来),因此每次碰撞的时候设置球的速度
        switch secondBody.categoryBitMask{
        case PhysicsCategory.TopBorder:
            ballVelY = -ballVelY
            ballSprite.physicsBody?.velocity = CGVectorMake(ballVelX, ballVelY)
        case PhysicsCategory.BottomBorder:
            self.showGameOverBanner()
            ballSprite.removeFromParent()
        case PhysicsCategory.LeftBorder, PhysicsCategory.RightBorder:
            ballVelX = -ballVelX
            ballSprite.physicsBody?.velocity = CGVectorMake(ballVelX, ballVelY)
        case PhysicsCategory.Bouncer:
            //FIX ME: 碰撞到左右边缘会吸附到上面, 而不会弹开
            ballVelY = -ballVelY
            ballSprite.physicsBody?.velocity = CGVectorMake(ballVelX, ballVelY)
        case PhysicsCategory.Brick:
            //==>判断撞击在brick的哪一测,并从场景中移除该brick节点
            if let brickSprite = secondBody.node as? BrickSprite {
                switch brickSprite.checkContactPos(contact.contactPoint) {
                //==>加入对速度方向的判断,避免碰到两个brick交接点时, 速度变化两次
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
                //print("remove brick at position (\(brickSprite.position.x), \(brickSprite.position.y))")
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
            ballSprite.physicsBody?.applyImpulse(CGVectorMake(-6, 6))
            ballVelX = (ballSprite.physicsBody?.velocity.dx)!
            ballVelY = (ballSprite.physicsBody?.velocity.dy)!
        }
        //==>anyObject和NSSet的含义?
        let anyTouch : AnyObject! = (touches as NSSet).anyObject()
        let location = anyTouch.locationInNode(self)
        let newX = min(max(bouncerSprite.size.width / 2, location.x), self.frame.size.width - bouncerSprite.size.width / 2)
        bouncerSprite.runAction(SKAction.moveTo(CGPoint(x: newX, y: bouncerSprite.position.y), duration: 0.1))
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let anyTouch : AnyObject! = (touches as NSSet).anyObject()
        let location = anyTouch.locationInNode(self)
        let newX = min(max(bouncerSprite.size.width / 2, location.x), self.frame.size.width - bouncerSprite.size.width / 2)
        bouncerSprite.runAction(SKAction.moveTo(CGPoint(x: newX, y: bouncerSprite.position.y), duration: 0.1))
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func showGameOverBanner() {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Game Over!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(myLabel)
    }
    
    func createLayoutByGameLevelsCfg() {
        //==>读取plist配置文件的方法
        let levels:String = NSBundle.mainBundle().pathForResource("GameLevels", ofType: "plist")!
        let levelsData:NSMutableDictionary = NSMutableDictionary(contentsOfFile: levels)!
        let level1 = levelsData.objectForKey("Level1") as! NSArray
        let level1BricksLayout0 = level1[0] as! NSArray
        let row0 = level1BricksLayout0[0] as! String
        print(row0)
    }
}
