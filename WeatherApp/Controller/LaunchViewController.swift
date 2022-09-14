//
//  LaunchViewController.swift
//  WeatherApp
//
//  Created by ArnoldKy on 8/18/22.
//

import UIKit

class LaunchViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let weatherGif = UIImage.gifImageWithName("weatherGif")
        imageView.image = weatherGif
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
             self.performSegue(withIdentifier: "mainWeatherView", sender: self)
        })
        
    }
}
