//
//  GameScene.swift
//  PhysicsFieldsWorld
//
//  Created by FloodSurge on 6/14/14.
//  Copyright (c) 2014 FloodSurge. All rights reserved.
//

import SpriteKit

enum FieldType{
    case LinearGravityFieldDown
    case LinearGravityFieldUp
    case RadialGravityField
    case DragField
    case VortexField
    case VelocityField
    case NoiseField
    case TurbulenceField
    case SpringField
    case ElectricField
    case MagneticField
}

class GameScene: SKScene {
    
    var shooter:SKSpriteNode!
    var fieldType:FieldType!
    
    override func didMoveToView(view: SKView) {
        
        rotateShooter()
        shootBall()
        
        fieldType = FieldType.LinearGravityFieldDown
        
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
    {
        let fieldTag = childNodeWithName("FieldTag")
        let fieldNode = childNodeWithName("FieldNode") as SKFieldNode
        let fieldCenter = childNodeWithName("PhysicsFieldCenter").position
        
        switch fieldType!{
        case .LinearGravityFieldDown:
            fieldTag.runAction(SKAction.rotateByAngle(M_PI, duration: 0.5))
            fieldNode.runAction(SKAction.rotateByAngle(M_PI, duration: 0.5))
            fieldType = FieldType.LinearGravityFieldUp
            
        case .LinearGravityFieldUp:
            fieldNode.runAction(SKAction.rotateByAngle(M_PI, duration: 0.5))
            fieldNode.strength = 0
            changeTagTo("RadialGravityFieldTag")
            fieldType = FieldType.RadialGravityField
            
            let radialGravityField = SKFieldNode.radialGravityField()
            radialGravityField.position = fieldCenter
            radialGravityField.name = "RadialGravityField"
            addChild(radialGravityField)
            
        case .RadialGravityField:
            changeTagTo("SpringFieldTag")
            fieldType = FieldType.SpringField
            let radialGravityField = childNodeWithName("RadialGravityField")
            radialGravityField.removeFromParent()
            
            let springField = SKFieldNode.springField()
            springField.strength = 0.05
            springField.falloff = -5
            springField.position = fieldCenter
            springField.name = "SpringField"
            addChild(springField)
            

            
        case .SpringField:
            changeTagTo("TurbulenceFieldTag")
            fieldType = FieldType.TurbulenceField
            
            let springField = childNodeWithName("SpringField")
            springField.removeFromParent()
            
            let turbulenceField = SKFieldNode.turbulenceFieldWithSmoothness(1, animationSpeed: 10)
            turbulenceField.position = fieldCenter
            turbulenceField.name = "TurbulenceField"
            addChild(turbulenceField)

        
        case .TurbulenceField:
            changeTagTo("VelocityFieldTag")
            fieldType = FieldType.VelocityField
            
            let turbulenceField = childNodeWithName("TurbulenceField")
            turbulenceField.removeFromParent()
            
            let velocityField = SKFieldNode.velocityFieldWithTexture(SKTexture(imageNamed:"VelocityFieldTag"))
            velocityField.name = "VelocityField"
            velocityField.position = fieldCenter
            addChild(velocityField)
            

            
        case .VelocityField:
            changeTagTo("VortexFieldTag")
            fieldType = FieldType.VortexField

            let velocityField = childNodeWithName("VelocityField")
            velocityField.removeFromParent()
            
            let vortexField = SKFieldNode.vortexField()
            vortexField.name = "VortexField"
            vortexField.position = fieldCenter
            vortexField.region = SKRegion(radius:40)
            vortexField.strength = 5
            vortexField.falloff = -1
            
            addChild(vortexField)
            
        case .VortexField:
            changeTagTo("NoiseFieldTag")
            fieldType = FieldType.NoiseField
            
            let vortexField = childNodeWithName("VortexField")
            vortexField.removeFromParent()
            
            let noiseField = SKFieldNode.noiseFieldWithSmoothness(0.8, animationSpeed:1)
            noiseField.position = fieldCenter
            noiseField.name = "NoiseField"
            noiseField.strength = 0.1
            
            addChild(noiseField)
            

            
        case .NoiseField:
            changeTagTo("DragFieldTag")
            fieldType = FieldType.DragField
            
            let noiseField = childNodeWithName("NoiseField")
            noiseField.removeFromParent()
            
            let dragField = SKFieldNode.dragField()
            dragField.position = fieldCenter
            dragField.region = SKRegion(radius: 50)
            dragField.name = "DragField"
            addChild(dragField)
            
            
            
        case .DragField:
            changeTagTo("LinearGravityFieldTag")
            fieldType = FieldType.LinearGravityFieldDown

            let dragField = childNodeWithName("DragField")
            dragField.removeFromParent()
            
            fieldNode.strength = 1
            
        case .MagneticField:
            fieldType = FieldType.ElectricField

            
            let magneticField = childNodeWithName("MagneticField")
            magneticField.removeFromParent()
            
            let electricField = SKFieldNode.electricField()
            electricField.position = fieldCenter
            electricField.name = "ElectricField"
            electricField.strength = -10
            addChild(electricField)
            
            
        case .ElectricField:
            changeTagTo("LinearGravityFieldTag")
            fieldType = FieldType.LinearGravityFieldDown
            
            let electricField = childNodeWithName("ElectricField")
            electricField.removeFromParent()
            
            fieldNode.strength = 1
            
        default:
            println("wrong")
        }
        
       
    }
    
    func changeTagTo(tagName:String){
        let fieldTag = childNodeWithName("FieldTag")
        let texture = SKTexture(imageNamed:tagName)
        fieldTag.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.2),
            SKAction.animateWithTextures([texture], timePerFrame: 0),SKAction.fadeInWithDuration(0.2)]))
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func rotateShooter()
    {
        let shooter = childNodeWithName("shooter")
        let rotateClockwiseAction = SKAction.rotateToAngle(M_PI_4, duration: 1)
        let rotateAntiClockwiseAction = SKAction.rotateToAngle(-M_PI_4, duration: 1)
        let rotateForeverAction = SKAction.repeatActionForever(SKAction.sequence([rotateAntiClockwiseAction,rotateClockwiseAction]))
        shooter.runAction(rotateForeverAction)
    }
    
    func shootBall()
    {
        
        let creatBallAction = SKAction.runBlock({() in
            let shooter = self.childNodeWithName("shooter")
            
            let rotation = shooter.zRotation
            
            let ballTexture = SKTexture(imageNamed:"ball")
            let ball = SKSpriteNode(texture:ballTexture)
            ball.physicsBody = SKPhysicsBody(circleOfRadius: 5)
            
            ball.position = CGPointMake(shooter.position.x + CGFloat( cosf(CFloat(rotation)) * 25), shooter.position.y + CGFloat( sinf(CFloat(rotation)) * 25))
            
            let velocity = CGFloat( arc4random() % 300 + 100)
            //let velocity = CGFloat(50)
            ball.physicsBody.velocity = CGVectorMake(velocity * CGFloat( cosf(CFloat(rotation))), velocity * CGFloat(sinf(CFloat(rotation))))
            ball.physicsBody.charge = -10
            
            let ballTrail = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("BallTrail2", ofType: "sks")) as SKEmitterNode
            ballTrail.position = CGPointMake(0, 0)
            ballTrail.targetNode = self
            
            ball.addChild(ballTrail)
            
            self.addChild(ball)
            
            })
        
        let wait = SKAction.waitForDuration(NSTimeInterval(Float(arc4random() % 100) / 100.0 + 0.2))
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([creatBallAction,wait])))
             
        
    }
}
