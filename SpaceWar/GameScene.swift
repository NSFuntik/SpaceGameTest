//
//  GameScene.swift
//  SpaceWar
//
//  Created by Mikhailov on 06.07.2020.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameViewControllerBridge: GameViewController!
    var gameOverViewControllerBridge: GameOverViewController!
    var didFinishScene: (() -> Void)?

    //MARK: - Bitmasks
    let spaceShipCategory: UInt32 = 0x1 << 0
    let asteroidCategory: UInt32 = 0x1 << 1
    
    var spaceShip: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var spaceBackground: SKSpriteNode!
    var asteroidLayer: SKNode!
    var starsLayer: SKNode!
    var spaceShipLayer: SKNode!
    var musicPlayer: AVAudioPlayer!
    var gameIsPaused = false
    var musicOn = true
    var soundOn = true
    var score = 0
    
    
    func musicToggle() {
        if musicOn { musicPlayer.play() }
        else { musicPlayer.stop() }
    }
    
    func restartGame() {
        spaceShipLayer.position = CGPoint(x: frame.midX, y: frame.midY )
        asteroidLayer.removeAllChildren()
        unpauseTheGame()
        score = 0
        scoreLabel.text = "Score: \(score)"
        playMusic()
    }
    
    func pauseTheGame() {
        gameIsPaused = true
        self.asteroidLayer.isPaused = true
        physicsWorld.speed = 0
        starsLayer.isPaused = true
        musicPlayer.pause()
    }
    
    func unpauseTheGame() {
        gameIsPaused = false
        self.asteroidLayer.isPaused = false
        physicsWorld.speed = 1
        starsLayer.isPaused = false
        musicToggle()
    }
    
    func resetTheGame() {
        gameIsPaused = false
        self.asteroidLayer.isPaused = false
        physicsWorld.speed = 1
        score = 0
        scoreLabel.text = "Score: \(score)"
    }
    
    override func didMove(to view: SKView) {
        scene?.size = UIScreen.main.bounds.size
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.8)
        
        //MARK: - Spacebackground config
        spaceBackground = SKSpriteNode(imageNamed: "spacebackground")
        spaceBackground.size = CGSize(width: UIScreen.main.bounds.width + 50, height: UIScreen.main.bounds.height + 50)
        spaceBackground.zPosition = 0
        addChild(spaceBackground)
        
        //MARK: - Stars config
        let starsPath = Bundle.main.path(forResource: "Stars", ofType: "sks")
        let starsEmitter = NSKeyedUnarchiver.unarchiveObject(withFile: starsPath!) as! SKEmitterNode
	
        starsEmitter.zPosition = 1
        starsEmitter.position = CGPoint(x: frame.midX, y: frame.height / 2)
        starsEmitter.particlePositionRange.dx = frame.width
        starsEmitter.advanceSimulationTime(10)
        
        starsLayer = SKNode()
        starsEmitter.zPosition = 1
        addChild(starsLayer)
        
        starsLayer.addChild(starsEmitter)
        
        //MARK: - Spaceship config
        spaceShip = SKSpriteNode(imageNamed: "spaceship")
        spaceShip.xScale = 0.5
        spaceShip.yScale = 0.5
        spaceShip.physicsBody = SKPhysicsBody(texture: spaceShip.texture!, size: spaceShip.size)
        spaceShip.physicsBody?.isDynamic = false
        
        spaceShip.physicsBody?.categoryBitMask = spaceShipCategory
        spaceShip.physicsBody?.collisionBitMask = asteroidCategory
        spaceShip.physicsBody?.contactTestBitMask = asteroidCategory
        
        let colorAction1 = SKAction.colorize(with: .orange, colorBlendFactor: 1, duration: 1)
        let colorAction2 = SKAction.colorize(with: .white, colorBlendFactor: 0, duration: 1)
        
        let colorSequenceAnimation = SKAction.sequence([colorAction1, colorAction2])
        let colorActionRepeat = SKAction.repeatForever(colorSequenceAnimation)
        
        spaceShip.run(colorActionRepeat)
        
        //MARK: - Layer for spaceship and fire
        spaceShipLayer = SKNode()
        spaceShipLayer.addChild(spaceShip)
        spaceShipLayer.zPosition = 3
        spaceShip.zPosition = 1
        spaceShipLayer.position = CGPoint(x: frame.midX, y: frame.midY )
        addChild(spaceShipLayer)
        
        //MARK: - Fire config
        let firePath = Bundle.main.path(forResource: "Fire", ofType: "sks")
        let fireEmitter = NSKeyedUnarchiver.unarchiveObject(withFile: firePath!) as! SKEmitterNode
        
        fireEmitter.zPosition = 0
        fireEmitter.position.y = -40
        fireEmitter.targetNode = self
        spaceShipLayer.addChild(fireEmitter)
        
        
        //MARK: - Asteroids generate
        asteroidLayer = SKNode()
        asteroidLayer.zPosition = 2
        addChild(asteroidLayer)
        
        let asteroidCreate = SKAction.run {
            let asteroid = self.createAsteroid()
            self.asteroidLayer.addChild(asteroid)
            asteroid.zPosition = 2
        }
        
        let asteroidPerSecond: Double = 2
        let asteroidCreationDelay = SKAction.wait(forDuration: 1.0 / asteroidPerSecond, withRange: 0.5)
        let asteroidSequenceAction = SKAction.sequence([asteroidCreate, asteroidCreationDelay])
        let asteroidRunAction = SKAction.repeatForever(asteroidSequenceAction)
        
        self.asteroidLayer.run(asteroidRunAction)
        
        //MARK: - Score label config
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.position = CGPoint(x: frame.size.width / scoreLabel.frame.size.width, y: 200)
        scoreLabel.zPosition = 3
        addChild(scoreLabel)
        
        playMusic()
    }
    
    func playMusic() {
        if let musicPath = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3") {
            musicPlayer = try! AVAudioPlayer(contentsOf: musicPath, fileTypeHint: nil)
            musicToggle()
        }
        musicPlayer.numberOfLoops = -1
        musicPlayer.volume = 0.3
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            //print(touchLocation)
            let distance = distanceCalc(a: spaceShip.position, b: touchLocation)
            let speed: CGFloat = 500
            let time = timeToTravelDistance(distance: distance, speed: speed)
            let moveAction = SKAction.move(to: touchLocation, duration: time)
            moveAction.timingMode = SKActionTimingMode.easeInEaseOut
            spaceShipLayer.run(moveAction)
            
            let bgMoveAction = SKAction.move(to: CGPoint(x: -touchLocation.x / 50, y: -touchLocation.y / 50), duration: time)
            spaceBackground.run(bgMoveAction)
        }
    }
    
    func distanceCalc(a: CGPoint, b: CGPoint) -> CGFloat {
        return sqrt((b.x - a.x)*(b.x - a.x) + (b.y - a.y)*(b.y - a.y))
    }
    
    func timeToTravelDistance(distance: CGFloat, speed: CGFloat) -> TimeInterval {
        let time = distance / speed
        return TimeInterval(time)
    }
    
    //MARK: - Asteroids creating config
    func createAsteroid() -> SKSpriteNode {
        let asteroid = SKSpriteNode(imageNamed: "asteroid")
        
        let randomScale = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 6)) / 5
        asteroid.xScale = randomScale
        asteroid.yScale = randomScale
        
        asteroid.position.x = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 16))
        asteroid.position.y = frame.size.height + asteroid.size.height
        
        asteroid.physicsBody = SKPhysicsBody(texture: asteroid.texture!, size: asteroid.size)
        asteroid.name = "asteroid"
        
        asteroid.physicsBody?.categoryBitMask = asteroidCategory
        asteroid.physicsBody?.collisionBitMask = spaceShipCategory | asteroidCategory
        asteroid.physicsBody?.contactTestBitMask = spaceShipCategory
        
        let asteroidSpeed: CGFloat = 90.0
        asteroid.physicsBody?.angularVelocity = CGFloat(drand48() * 2 - 1) * 3
        asteroid.physicsBody?.velocity.dx = CGFloat(drand48() * 2 - 1) * asteroidSpeed
        
        return asteroid
    }
    
    
    override func didSimulatePhysics() {
        asteroidLayer.enumerateChildNodes(withName: "asteroid") { (asteroid, stop) in
            let heightScreen = UIScreen.main.bounds.height
            if asteroid.position.y < -heightScreen {
                asteroid.removeFromParent()
                
                self.score += 1
                self.scoreLabel.text = "Score: \(self.score)"
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == spaceShipCategory && contact.bodyB.categoryBitMask == asteroidCategory || contact.bodyB.categoryBitMask == spaceShipCategory && contact.bodyA.categoryBitMask == asteroidCategory   {
            
            pauseTheGame()
            
            gameViewControllerBridge.addChild(gameOverViewControllerBridge)
            gameViewControllerBridge.view.addSubview(gameOverViewControllerBridge.view)
            gameOverViewControllerBridge.view.frame = gameViewControllerBridge.view.bounds

            gameOverViewControllerBridge.scoreLabel.text = "\(self.score)"
            
            let maxScore = UserDefaults.standard.integer(forKey: "record")
            if maxScore < score {
                UserDefaults.standard.set(score, forKey: "record")
            }
            
            // animation
            gameOverViewControllerBridge.view.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.gameOverViewControllerBridge.view.alpha = 1
            }
        }
        let hitSoundAction = SKAction.playSoundFileNamed("hitSound", waitForCompletion: true)
        run(hitSoundAction)
    }
}

