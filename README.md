## SwiftMapKit Uygulama Kullanımı
| Oyun Başlıyor | Oyun Devam Ediyor |
|---------|---------|
| ![Video 1](https://github.com/user-attachments/assets/81c493fd-c283-45d4-b85a-085b353e0177) | ![Video 2](https://github.com/user-attachments/assets/7731ed1f-cf52-420a-a627-9f0a4dbb5936) |

 <details>
    <summary><h2>Oyunun Amacı</h2></summary>
    Proje Amacı
   Bu oyun, oyuncuların renkli havai fişekleri patlatmak için doğru stratejiyi kullanmalarını gerektiren bir mobil oyunudur. Oyuncu, ekranda rastgele patlayan havai fişekleri seçip patlatarak puan kazanmaya çalışır. Hedef, ekranı doğru renkli havai fişeklerle doldurmak ve mümkün olduğunca fazla sayıda havai fişek patlatarak yüksek puanlar elde etmektir.
   Her seferinde farklı bir yöne giden havai fişekler ortaya çıkar, bu nedenle oyuncunun doğru zamanlamayı yaparak en yüksek puanı elde etmesi için dikkatli olması gerekir. Birden fazla havai fişeği aynı anda patlatmak, daha yüksek puanlar kazandırır.
   Oyun, hızlı refleksler ve doğru renk seçimleri yapabilme yeteneğini test eder ve oyuncuları eğlenceli bir şekilde meydan okur.
  </details>  

  <details>
    <summary><h2>didMove(to view: SKView)</h2></summary>
    didMove(to:): Bu fonksiyon, sahne ilk yüklendiğinde çalışır. Yani oyun başladığında yapılacak ayarlamalar burada yapılır.
    background: Arka plan görüntüsünü yükler ve sahnenin ortasına yerleştirir.
    position: Arka planın merkezde (512, 384) konumlandırılmasını sağlar.
    blendMode: Blend modunu .replace yaparak arka planın düzgün bir şekilde görünmesini sağlar.
    zPosition: Arka planın diğer öğelerin arkasında kalması için -1 olarak ayarlanır.
    gameTimer: 6 saniyede bir launchFireworks fonksiyonunu çağırmak için bir zamanlayıcı oluşturur. Bu, havai fişeklerin periyodik olarak başlatılmasını sağlar
    
    ```
    override func didMove(to view: SKView) {
    let background = SKSpriteNode(imageNamed: "background")
    background.position = CGPoint(x: 512, y: 384)
    background.blendMode = .replace
    background.zPosition = -1
    addChild(background)
    
    gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
     }




    ```
  </details> 

  <details>
    <summary><h2>createFirework(xMovement: CGFloat, x: Int, y: Int)</h2></summary>
    node: Havai fişeği temsil eden bir SKNode nesnesi oluşturur.
    firework: Görsel olarak havai fişeği temsil eden SKSpriteNode.
    colorBlendFactor: Renk karıştırma faktörünü 1 yaparak renklerin tam olarak uygulanmasını sağlar.
     name: Havai fişeği seçilebilir hale getirmek için adını "firework" olarak ayarlar.
     switch: Havai fişeklerin rastgele olarak cyan, green veya red renklerinden birine sahip olmasını sağlar.
     path ve move: Havai fişeğin hareket edeceği yolu tanımlar.
     move: Havai fişeğin yukarı doğru (1000 piksel) belirli bir hızda hareket etmesini sağlar.
    emitter: Havai fişeğin alt kısmına, ateşleme efektini gösteren bir parçacık sistemi ekler.
    fireworks.append(node): Yeni oluşturulan havai fişeği fireworks dizisine ekler.
    addChild(node): Havai fişeği sahneye ekler.

    
    ```
     func createFirework(xMovement: CGFloat , x: Int , y: Int) {
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

    ```
  </details> 

  <details>
    <summary><h2>launchFireworks()</h2></summary>
   movementAmount: Havai fişeklerin sağa veya sola hareket etmesi için mesafe değeri.
    switch: Havai fişeklerin 4 farklı şekilde fırlatılmasını sağlar:
    case 0: Havai fişekler ekrandan yukarı doğru düz bir çizgi halinde fırlatılır.
     case 1: Havai fişekler yukarı doğru hafif bir eğimle sağa ve sola hareket ederek fırlatılır.
     case 2: Havai fişekler ekranın solundan yukarı doğru çapraz bir çizgi halinde fırlatılır.
     case 3: Havai fişekler ekranın sağından yukarı doğru çapraz bir çizgi halinde fırlatılır.
    
    ```
         @objc func launchFireworks() {
    let movementAmount: CGFloat = 1800
    switch Int.random(in: 0...3) {
    case 0:
        createFirework(xMovement: 0, x: 512, y: bottomEdge)
        createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
        createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
        createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
        createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
    case 1:
        createFirework(xMovement: 0, x: 512, y: bottomEdge)
        createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
        createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
        createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
        createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
    case 2:
        createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
        createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
        createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
        createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
        createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
    case 3:
        createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
        createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
        createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
        createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
        createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
    default:
        break
    }
    }



    
    ```
  </details> 


  

  


<details>
    <summary><h2>Uygulama Görselleri </h2></summary>
    
    
 <table style="width: 100%;">
    <tr>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Oyundan Gorseller 1</h4>
            <img src="https://github.com/user-attachments/assets/cd6e6055-e710-4b12-bf0e-25092763264e" style="width: 100%; height: auto;">
        </td>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Oyundan Gorseller 2</h4>
            <img src="https://github.com/user-attachments/assets/cffc0627-2946-46ae-9a11-5720f86ac30d" style="width: 100%; height: auto;">
        </td>
    </tr>
</table>
  </details> 
