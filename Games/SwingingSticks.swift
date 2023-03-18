//
//  GameOfLife.swift
//  Games
//
//  Created by Jack Finnis on 03/02/2023.
//

import SwiftUI
import SpriteKit

struct SwingingSticksView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var reset = false
    
    var body: some View {
        GeometryReader { geo in
            SpriteView(scene: SwingingSticks(size: geo.size), options: [.allowsTransparency])
                .id(reset)
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                reset.toggle()
                Haptics.tap()
            } label: {
                Image(systemName: "arrow.counterclockwise")
            }
            .font(.title2)
            .padding()
        }
    }
}

struct SwingingSticksView_Previews: PreviewProvider {
    static var previews: some View {
        SwingingSticksView()
    }
}

class SwingingSticks: SKScene {
    var one = SKSpriteNode()
    var two = SKSpriteNode()
    var moving: SKSpriteNode?
    var point: CGPoint?
    
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        backgroundColor = .clear
//        physicsWorld.speed = 100
        
        let length = size.width / 5
        one = SKSpriteNode()
        one.size = CGSize(width: 5, height: length)
        let oneShape = SKShapeNode(rectOf: CGSize(width: 5, height: length + 5), cornerRadius: 2.5)
        oneShape.fillColor = UIColor(.blue)
        oneShape.strokeColor = .clear
        one.addChild(oneShape)
        one.zPosition = 1
        one.position = view.center.applying(CGAffineTransform(translationX: 0, y: length/2))
        one.physicsBody = SKPhysicsBody(rectangleOf: one.size)
        one.physicsBody?.angularDamping = -9
        one.physicsBody?.linearDamping = -0.1
        addChild(one)
        
        two = SKSpriteNode()
        two.size = CGSize(width: 5, height: length)
        let twoShape = SKShapeNode(rectOf: CGSize(width: 5, height: length + 5), cornerRadius: 2.5)
        twoShape.fillColor = UIColor(.red)
        twoShape.strokeColor = .clear
        two.addChild(twoShape)
        two.zPosition = 0
        two.position = view.center.applying(CGAffineTransform(translationX: 0, y: length * 3/2))
        two.physicsBody = SKPhysicsBody(rectangleOf: two.size)
        addChild(two)
        
        let emitter = SKEmitterNode(fileNamed: "Trail")!
        emitter.position.y = length/2
        emitter.targetNode = self
        emitter.particleZPosition = -1
        emitter.particleColorSequence = nil
        emitter.particleColorBlendFactor = 1
        emitter.particleColor = .init(white: UITraitCollection.current.userInterfaceStyle == .light ? 0.9 : 0.3, alpha: 1)
        two.addChild(emitter)
        
        let fixed = SKPhysicsJointPin.joint(withBodyA: one.physicsBody!, bodyB: physicsBody!, anchor: view.center)
        physicsWorld.add(fixed)
        
        let joint = SKPhysicsJointPin.joint(withBodyA: one.physicsBody!, bodyB: two.physicsBody!, anchor: view.center.applying(CGAffineTransform(translationX: 0, y: length)))
        physicsWorld.add(joint)
        
        two.physicsBody?.applyImpulse(CGVectorMake(Double.random(in: -1...1), 0))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        point = location
        if one.contains(location) {
            moving = one
        } else if two.contains(location) {
            moving = two
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        moving = nil
        point = nil
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        if let moving, let point {
            let dt: Double = 1/50
            let distance = CGVector(dx: point.x - moving.position.x, dy: point.y - moving.position.y)
            let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
            moving.physicsBody!.velocity = velocity
        }
    }
}
