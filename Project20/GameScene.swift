//
//  GameScene.swift
//  Project20
//
//  Created by Eren Elçi on 10.11.2024.
//

import SpriteKit


class GameScene: SKScene {
    
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    var score = 0 {
        didSet {
            
        }
    }
    
    override func didMove(to view: SKView) {
        let backgorund = SKSpriteNode(imageNamed: "background")
        backgorund.position = CGPoint(x: 512, y: 384)
        backgorund.blendMode = .replace
        backgorund.zPosition = -1
        addChild(backgorund)
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    func creatFirework(xMovement: CGFloat , x: Int , y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        default:
            firework.color = .red
        }
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        fireworks.append(node)
        addChild(node)
    }
    
    @objc func launchFireworks(){
        let movementAmount : CGFloat = 1800
        switch Int.random(in: 0...3) {
        case 0:
            creatFirework(xMovement: 0, x: 512, y: bottomEdge)
            creatFirework(xMovement: 0, x: 512 - 200 , y: bottomEdge)
            creatFirework(xMovement: 0, x: 512 - 100 , y: bottomEdge)
            creatFirework(xMovement: 0, x: 512 + 100 , y: bottomEdge)
            creatFirework(xMovement: 0, x: 512 + 200 , y: bottomEdge)
        case 1:
            creatFirework(xMovement: 0, x: 512, y: bottomEdge)
            creatFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            creatFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            creatFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            creatFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
        case 2:
            creatFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            creatFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            creatFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            creatFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            creatFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
        case 3:
            creatFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            creatFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            creatFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            creatFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            creatFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
            
        default:
            break
        }
    }
    
    func  chechTouches(_ touches: Set<UITouch>) {
        guard let tocuh = touches.first else { return }
        let location = tocuh.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
                    
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        chechTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        chechTouches(touches)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y >  900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
            
        }
    }
    
    func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
        }

        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0

        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }

            if firework.name == "selected" {
                // destroy this firework!
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }

        switch numExploded {
        case 0:
            // nothing – rubbish!
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
}
