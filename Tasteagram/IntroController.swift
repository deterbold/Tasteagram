//
//  ViewController.swift
//  Tasteagram
//
//  Created by Miguel Sicart on 19/11/2021.
//

import UIKit
import Lumina

class IntroController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func cameraButtonTapped(_ sender: Any)
    {
        //code for setting up the camera and presenting the view goes here.
        //creating the camera view controller
        let camera = LuminaViewController()
        
        //setup for the camera goes here
        
        //presenting the camera view
        present(camera, animated: true, completion: nil)
    }
    
}

