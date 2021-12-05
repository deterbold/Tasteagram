//
//  ImageController.swift
//  Tasteagram
//
//  Created by Miguel Sicart on 19/11/2021.
//

import UIKit
import AVKit
import CoreML
import Lumina
import Vision

class ImageController: UIViewController
{

    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    var livePhotoURL: URL?
    var showingDepth: Bool = false
    var position: CameraPosition = .back
    private var _depthData: Any?
    
    
    private lazy var classificationRequest: VNCoreMLRequest =
    {
      do {
        // 2
        //let model = try VNCoreMLModel(for: prototype_taste().model)
          let model = try VNCoreMLModel(for: Tastegram_Hard().model)
          // 3
        let request = VNCoreMLRequest(model: model) { request, _ in
            if let classifications =
              request.results as? [VNClassificationObservation] {
              print("Classification results: \(classifications)")
                print(classifications.first!.identifier as String as Any)
                print(request.results?.first?.confidence as Any)
                let veredict = classifications.first!.identifier as String
                if veredict == "Good"
                {
                    print("good picture")
                    self.sendPicture()
                    
                }
                else if veredict == "Bad"
                {
                    print("bad picture")
                    self.sendText()
                }
                
            }
        }
        // 4
        request.imageCropAndScaleOption = .centerCrop
        return request
      } catch {
        // 5
        fatalError("Failed to load Vision ML model: \(error)")
      }
    }()
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.imageView.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func regretButton(_ sender: Any)
    {
        //performSegue(withIdentifier: "regretAndReturn", sender: nil)
        sendRegretText()
    }
    
    @IBAction func judgePicture(_ sender: Any)
    {
        classifyImage(image!)
    }
    
    func classifyImage(_ image: UIImage) {
      // 1
      guard let orientation = CGImagePropertyOrientation(
        rawValue: UInt32(image.imageOrientation.rawValue)) else {
        return
      }
      guard let ciImage = CIImage(image: image) else {
        fatalError("Unable to create \(CIImage.self) from \(image).")
      }
      // 2
      DispatchQueue.global(qos: .userInitiated).async {
        let handler =
          VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
        do {
          try handler.perform([self.classificationRequest])
        } catch {
          print("Failed to perform classification.\n\(error.localizedDescription)")
        }
      }
    }
    
    func sendPicture()
    {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "sucessControllerSegue", sender: self)

        }
    }
    
    func sendText()
    {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "failureSegue", sender: self)
        }
    }
    
    func sendRegretText()
    {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "regretAndReturn", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "sucessControllerSegue" {
            let dvc = segue.destination as! SuccessController
            dvc.image = self.image
        }
        
        if segue.identifier == "failureSegue" {
            let dvc = segue.destination as! IntroController
            dvc.labelText = "That was Not a Good Picture. Try Again"
        }
        
        if segue.identifier == "regretAndReturn"
        {
            let dvc = segue.destination as! IntroController
            dvc.labelText = "let the AI decide"
        }
    }
}

