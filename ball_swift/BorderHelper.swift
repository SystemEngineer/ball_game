//
//  Border.swift
//  ball_swift
//
//  Created by 荣徽 贺 on 16/4/29.
//  Copyright © 2016年 荣徽 贺. All rights reserved.
//

import SpriteKit

class BorderHelper {
    var bottomBorder: SKNode
    var topBorder: SKNode
    var leftBorder: SKNode
    var rightBorder: SKNode
    
    init() {
        bottomBorder = SKNode()
        topBorder = SKNode()
        leftBorder = SKNode()
        rightBorder = SKNode()
    }//==>成员变量必须在构造函数赋值, 否则会报错, 如果某些成员变量无需赋值, 可设置为optional变量
    
    internal func createBorder(sceneFrameRect: CGRect) {
        let bottomBorderRect = CGRectMake(sceneFrameRect.origin.x, sceneFrameRect.origin.y, sceneFrameRect.width, 1)
        bottomBorder.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomBorderRect)
        bottomBorder.physicsBody?.categoryBitMask = PhysicsCategory.BottomEdge
        
        let topBorderRect = CGRectMake(sceneFrameRect.origin.x, sceneFrameRect.origin.y + sceneFrameRect.height - 1, sceneFrameRect.width, 1)
        topBorder.physicsBody = SKPhysicsBody(edgeLoopFromRect: topBorderRect)
        topBorder.physicsBody?.categoryBitMask = PhysicsCategory.TopEdge
        
        let leftBorderRect = CGRectMake(sceneFrameRect.origin.x, sceneFrameRect.origin.y, 20.0, sceneFrameRect.height)
        leftBorder.physicsBody = SKPhysicsBody(edgeLoopFromRect: leftBorderRect)
        leftBorder.physicsBody?.categoryBitMask = PhysicsCategory.LeftEdge
        
        let rightBorderRect = CGRectMake(sceneFrameRect.origin.x + sceneFrameRect.width - 20.0, sceneFrameRect.origin.y, 20.0, sceneFrameRect.height)
        rightBorder.physicsBody = SKPhysicsBody(edgeLoopFromRect: rightBorderRect)
        rightBorder.physicsBody?.categoryBitMask = PhysicsCategory.RightEdge

    }
    
    internal func addBorderToScene(scene: SKScene) {
        scene.addChild(bottomBorder)
        scene.addChild(topBorder)
        scene.addChild(leftBorder)
        scene.addChild(rightBorder)
    }
}
