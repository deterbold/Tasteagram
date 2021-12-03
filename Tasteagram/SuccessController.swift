//
//  SuccessController.swift
//  Tasteagram
//
//  Created by Miguel Sicart on 19/11/2021.
//

import UIKit
import Lumina
import Photos

class SuccessController: UIViewController
{
    @IBOutlet weak var tastyImage: UIImageView!
    
    var image: UIImage?    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        tastyImage.image = image
        
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)

    }
    
    //https://stackoverflow.com/questions/35931946/basic-example-for-sharing-text-or-image-with-uiactivityviewcontroller-in-swift
    
    @IBAction func shareButton(_ sender: Any)
    {
        // image to share
        //let image = UIImage(named: "Image")
               
        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
               
        // exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
               
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func tryAgain(_ sender: Any)
    {
        performSegue(withIdentifier: "tryAgainSegue", sender: nil)
    }
    
    
}
