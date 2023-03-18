//
//  GameOfLife.swift
//  Games
//
//  Created by Jack Finnis on 03/02/2023.
//

import SwiftUI
import SpriteKit

struct SwingingSticksView: View {
    var body: some View {
        GeometryReader { geo in
            SpriteView(scene: SwingingSticks(size: geo.size), options: [.allowsTransparency])
        }
    }
}

struct SwingingSticksView_Previews: PreviewProvider {
    static var previews: some View {
        SwingingSticksView()
    }
}

class SwingingSticks: SKScene {
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        backgroundColor = .clear
//        physicsWorld.speed = 1000
        
        let length = size.width / 5
        let one = SKSpriteNode(color: UIColor(.blue), size: CGSize(width: 5, height: length))
        one.position = view.center.applying(CGAffineTransform(translationX: 0, y: length/2))
        one.physicsBody = SKPhysicsBody(rectangleOf: one.size)
        one.physicsBody?.angularDamping = -9
        addChild(one)
        
        let two = SKSpriteNode(color: UIColor(.red), size: CGSize(width: 5, height: length))
        two.position = view.center.applying(CGAffineTransform(translationX: 0, y: length * 3/2))
        two.physicsBody = SKPhysicsBody(rectangleOf: two.size)
        addChild(two)
        
        let fixed = SKPhysicsJointPin.joint(withBodyA: one.physicsBody!, bodyB: physicsBody!, anchor: view.center)
        physicsWorld.add(fixed)
        
        let joint = SKPhysicsJointPin.joint(withBodyA: one.physicsBody!, bodyB: two.physicsBody!, anchor: view.center.applying(CGAffineTransform(translationX: 0, y: length)))
        physicsWorld.add(joint)
        
        two.physicsBody?.applyImpulse(CGVectorMake(1, 0))
    }
}

//one.physicsBody?.angularDamping = 0
//one.physicsBody?.linearDamping = 0
//fixed.frictionTorque = 0
