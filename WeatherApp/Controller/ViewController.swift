//
//  ViewController.swift
//  WeatherApp
//
//  Created by ArnoldKy on 8/11/22.
//

import UIKit
import GoogleMaps
import CoreLocation
import CoreLocation
import Firebase
import Foundation

class ViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {

    
    
    @IBOutlet var MapView: GMSMapView!
    

    
    let locationManager = CLLocationManager()
    var DateRefUpdate = 10.0
    var timer = Timer()
    var Timeint = 7.0
    
    override func viewDidLoad() {

        super.viewDidLoad()


        self.setUp()
        self.Firebase_UpdateMarkers()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: Timeint, repeats: true, block: { _ in
            self.deleteOld_docs()
            })
        
        
       
        
    }
    
    func setUp(){
        
        locationManager.requestWhenInUseAuthorization()
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.startUpdatingLocation()
       
        
    }
    
    func deleteOld_docs(){
        let db = Firestore.firestore()
        db.collection("Coordinates").addSnapshotListener { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            var count = 2
            for document in querySnapshot!.documents {
                if let date = document.get("DateCreated")  {
                    
                    let dateD = date as! Double
                    
                    let dateInterv = NSDate().timeIntervalSince1970 - dateD
                    
                    if dateInterv > self.DateRefUpdate {
                        
                        document.reference.delete()
                        print("delete")
                        
                    }
                    
                    print("\(dateInterv), date is hhhheeeerrrrrrreeeeee") //here you can
                    
                    }

                    count = count + 1
                }
            }
        }
        }
        
    
    
    @objc
     func Firebase_UpdateMarkers(){
         
        let db = Firestore.firestore()
        db.collection("Coordinates").addSnapshotListener { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            self.MapView.clear()
            var count = 2
            for document in querySnapshot!.documents {
                if let coords = document.get("coordinate") {
                    let point = coords as! GeoPoint
                    let lat = point.latitude
                    let lon = point.longitude
                    print(lat, lon) //here you can
                    let coor = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    let marker = GMSMarker(position: coor)
                    if let imageStr = document.get("Pic") {
                        let markerImage = UIImage(named: imageStr as! String )!.withRenderingMode(.alwaysTemplate)
                        let markerView = UIImageView(image: markerImage)
                        markerView.tintColor = UIColor.systemCyan
                        marker.iconView = markerView
                    }
                    marker.map =  self.MapView
                    
                    
                    
                    count = count + 1
                }
            }
        }
        }
        
        MapView.delegate = self
        
    }
    
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
//        let camera = GMSCameraPosition.camera(withLatitude: 40.7128,
//                                              longitude: 74.0060,
//                                                                  zoom: 6.0)
        
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude,
                                              zoom: 6.0)
        
    
        MapView.camera = camera
        MapView.animate(to: camera)
    
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
      print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")

        let detailVc = OptionViewController()
        let navVC = UINavigationController(rootViewController: detailVc)
        navVC.modalPresentationStyle = .automatic
        detailVc.coordinatel = coordinate.latitude
        detailVc.coordinateL = coordinate.longitude
        
        present(navVC, animated: true)
        
    }
     
    
    
    
    
    
}

    

