//
//  ViewController.swift
//  Tasteagram
//
//  Created by Miguel Sicart on 19/11/2021.
//

import UIKit
import AVKit
import Lumina

class IntroController: UIViewController
{
    
    @IBOutlet weak var decision_label: UILabel!
    
    var labelText = "let the AI decide"
    
    var creativeMode: Int?

    
    @IBAction func settingsButton(_ sender: Any)
    {
        chooseModel()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        decision_label.font = UIFont(name: "Futura Medium", size: 28)
        decision_label.adjustsFontSizeToFitWidth = true
        decision_label.allowsDefaultTighteningForTruncation = true
        decision_label.numberOfLines = 0
        decision_label.textAlignment = .center
        decision_label.text = labelText
        
        creativeMode = 0
    }
    

    @IBAction func cameraButtonTapped(_ sender: Any)
    {
        switch creativeMode
        {
        case 0:
            decision_label.text = "Standard Mode"
        case 1:
            decision_label.text = "Art Mode"
        case 2:
            decision_label.text = "Extremes Mode"
        case 3:
            decision_label.text = "Influencer Mode"
        default:
            decision_label.text = "Standard Mode"
            
        }
        //code for setting up the camera and presenting the view goes here.
        //creating the camera view controller
        let camera = LuminaViewController()
        camera.delegate = self
        
        //setup for the camera goes here
        
        //presenting the camera view
        camera.modalPresentationStyle = .fullScreen
        present(camera, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
      if segue.identifier == "showImageController"{
        guard let controller = segue.destination as? ImageController else { return }
        if let map = sender as? [String: Any] {
          controller.image = map["stillImage"] as? UIImage
          controller.livePhotoURL = map["livePhotoURL"] as? URL
          guard let positionBool = map["isPhotoSelfie"] as? Bool else { return }
          controller.position = positionBool ? .front : .back
            controller.creativeMode = self.creativeMode
        } else { return }
      }
    }
    
    
    
    /**
     Simple Alert with more than 2 buttons
     */
    func chooseModel() {
        let alert = UIAlertController(title: "Model Selection", message: "Choose a Judging Model", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Standard Mode", style: .default, handler: { (_) in
            print("You've pressed default")
            
            self.decision_label.text = "Standard Mode"
            self.creativeMode = 0
        }))

        alert.addAction(UIAlertAction(title: "Art Mode", style: .default, handler: { (_) in
            print("You've pressed cancel")
            self.decision_label.text = "Art Mode"
            self.creativeMode = 1
        }))
        
        alert.addAction(UIAlertAction(title: "Extremes Mode", style: .default, handler: { (_) in
            print("You've pressed cancel")
            self.decision_label.text = "Extremes Mode"
            self.creativeMode = 2
        }))
        
        alert.addAction(UIAlertAction(title: "Influencer Mode", style: .default, handler: { (_) in
            print("You've pressed cancel")
            self.decision_label.text = "Influencer Mode"
            self.creativeMode = 3
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            print("You've pressed the destructive")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension IntroController: LuminaDelegate
{
    func captured(stillImage: UIImage, livePhotoAt: URL?, depthData: Any?, from controller: LuminaViewController) {
        controller.dismiss(animated: true) {
            self.performSegue(withIdentifier: "showImageController", sender: ["stillImage": stillImage, "livePhotoURL": livePhotoAt as Any, "depthData": depthData as Any, "isPhotoSelfie": controller.position == .front ? true : false])
        }
    }

    
//    func captured(stillImage: UIImage, livePhotoAt: URL?, depthData: Any?, from controller: LuminaViewController){
//      controller.dismiss(animated: true) {
//        self.performSegue(withIdentifier: "stillImageOutputSegue", sender: ["stillImage": stillImage, "livePhotoURL": livePhotoAt as Any, "depthData": depthData as Any, "isPhotoSelfie": controller.position == .front ? true : false])
//      }
//    }
//
      //This is for capturing video. Not needed in the first version
//    func captured(videoAt: URL, from controller: LuminaViewController) {
//        <#code#>
//    }
//
//    func streamed(videoFrame: UIImage, from controller: LuminaViewController) {
//        <#code#>
//    }
//
//    func streamed(videoFrame: UIImage, with predictions: [LuminaRecognitionResult]?, from controller: LuminaViewController) {
//        <#code#>
//    }
//
//    func streamed(depthData: Any, from controller: LuminaViewController) {
//        <#code#>
//    }
//
    func detected(metadata: [Any], from controller: LuminaViewController) {
        print(metadata)
    }
    
    func dismissed(controller: LuminaViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
//    func tapped(at: CGPoint, from controller: LuminaViewController) {
//        <#code#>
//    }
    
}

extension CVPixelBuffer
{
  func normalizedImage(with position: CameraPosition) -> UIImage? {
    let ciImage = CIImage(cvPixelBuffer: self)
    let context = CIContext(options: nil)
    if let cgImage = context.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(self), height: CVPixelBufferGetHeight(self))) {
      return UIImage(cgImage: cgImage, scale: 1.0, orientation: getImageOrientation(with: position))
    } else {
      return nil
    }
  }

  private func getImageOrientation(with position: CameraPosition) -> UIImage.Orientation {
    let orientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation ?? .portrait
    switch orientation {
      case .landscapeLeft:
        return position == .back ? .down : .upMirrored
      case .landscapeRight:
        return position == .back ? .up : .downMirrored
      case .portraitUpsideDown:
        return position == .back ? .left : .rightMirrored
      case .portrait:
        return position == .back ? .right : .leftMirrored
      case .unknown:
        return position == .back ? .right : .leftMirrored
      @unknown default:
        return position == .back ? .right : .leftMirrored
    }
  }
}
