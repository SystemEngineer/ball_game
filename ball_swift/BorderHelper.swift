//
//  Border.swift
//  ball_swift
//
//  Created by 荣徽 贺 on 16/4/29.
//  Copyright © 2016年 荣徽 贺. All rights reserved.
//

import SpriteKit

class BorderHelper {
    //==>成员变量必须在构造函数赋值, 否则会报错, 如果某些成员变量无需赋值, 可设置为optional变量
    var bottomBorder: SKNode?
    var topBorder: SKNode?
    var leftBorder: SKSpriteNode?
    var rightBorder: SKSpriteNode?
    
    internal func createBorder(sceneFrameRect: CGRect) {
        bottomBorder = SKNode()
        let bottomBorderRect = CGRectMake(sceneFrameRect.origin.x, sceneFrameRect.origin.y, sceneFrameRect.width, 1)
        bottomBorder!.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomBorderRect)
        bottomBorder!.physicsBody?.categoryBitMask = PhysicsCategory.BottomBorder
        
        topBorder = SKNode()
        let topBorderRect = CGRectMake(sceneFrameRect.origin.x, sceneFrameRect.origin.y + sceneFrameRect.height - 1, sceneFrameRect.width, 1)
        topBorder!.physicsBody = SKPhysicsBody(edgeLoopFromRect: topBorderRect)
        topBorder!.physicsBody?.categoryBitMask = PhysicsCategory.TopBorder
        
        let sizeOfLeftRightBorder = CGSize(width: 60, height: sceneFrameRect.height)
        let posOfLeftBorder = CGPoint(x: CGRectGetMinX(sceneFrameRect) + sizeOfLeftRightBorder.width / 2, y: CGRectGetMidY(sceneFrameRect))
        let posOfRightBorder = CGPoint(x: CGRectGetMaxX(sceneFrameRect) - sizeOfLeftRightBorder.width / 2, y: CGRectGetMidY(sceneFrameRect))
        
        leftBorder = SKSpriteNode(color: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), size: sizeOfLeftRightBorder)
        leftBorder!.position = posOfLeftBorder
        leftBorder!.physicsBody = SKPhysicsBody(rectangleOfSize: sizeOfLeftRightBorder)
        leftBorder!.physicsBody?.categoryBitMask = PhysicsCategory.LeftBorder
        leftBorder!.physicsBody?.dynamic = false    //==>不设置为false, sprite会抖动甚至倾斜, why?
        
        rightBorder = SKSpriteNode(color: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), size: sizeOfLeftRightBorder)
        rightBorder!.position = posOfRightBorder
        rightBorder!.physicsBody = SKPhysicsBody(rectangleOfSize: sizeOfLeftRightBorder)
        rightBorder!.physicsBody?.categoryBitMask = PhysicsCategory.RightBorder
        rightBorder!.physicsBody?.dynamic = false
    }
    
    internal func addBorderToScene(scene: SKScene) {
        scene.addChild(bottomBorder!)
        scene.addChild(topBorder!)
        scene.addChild(leftBorder!)
        scene.addChild(rightBorder!)
    }
}
