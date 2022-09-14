//
//  OptionViewController.swift
//  WeatherApp
//
//  Created by CHRISTIAN BEYNIS on 8/12/22.
//

import UIKit
import Firebase
import GoogleMaps
import CoreLocation


class OptionViewController: UIViewController {
    let locationManager = CLLocationManager()
    var coordinatel: Double = 1.0
    var coordinateL: Double = 1.0
    var profiles: [Profile] = []
    let Radius = 50.0

    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .systemFill
        return collectionView
    }()
    

    private enum LayoutConstant {
        static let spacing: CGFloat = 20.0
        static let itemHeight: CGFloat = 200.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Add Weather Markers"
        setupViews()
        setupLayouts()
        populateProfiles()
        collectionView.reloadData()
    }

    private func setupViews() {
        view.backgroundColor = .systemFill
        view.addSubview(collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CloudsCollectionViewCell.self, forCellWithReuseIdentifier: CloudsCollectionViewCell.identifier)
    }

    private func setupLayouts() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private func populateProfiles() {
        profiles = [
            Profile(name: "Weather1", location: "Boston", imageName: "cloud.bolt", Option: "astronomy"),
            Profile(name: "Mike", location: "Albequerque", imageName: "cloud.drizzle", Option: "basketball"),
            Profile(name: "Walter White", location: "New Mexico", imageName: "cloud.fog", Option: "chemistry"),
            Profile(name: "Weather2", location: "California", imageName: "cloud.rain", Option: "geography"),
            Profile(name: "Chopin", location: "Norway", imageName: "cloud.snow", Option: "geometry"),
            Profile(name: "Castles", location: "UK", imageName: "sun.max", Option: "history"),
        ]
    }
    
    
    @objc
    func progButtonPressed(value: Int) {
        print("Button Was Tapped for:", "\(coordinatel), \(coordinateL), will add values later")

        let db = Firestore.firestore()

        db.collection("Coordinates").getDocuments()
        { [self]
            (querySnapshot, err) in

            if let err = err
            {
                print("Error getting documents: \(err)");
            }
            else
            {
            var Arr: [Double] = []
                var count = 0
                for document in querySnapshot!.documents {
                    
                    if let coords = document.get("coordinate") {
                        let point = coords as! GeoPoint
                        let lat = point.latitude
                        let lon = point.longitude
                        print(lat, lon) //here you can
                        let coor = CLLocation(latitude: lat, longitude: lon)
                        
                        if OneDistances(coordinatel: self.coordinatel, coordinateL: self.coordinateL, coor: coor) > self.Radius{
                            Arr.append(OneDistances(coordinatel: self.coordinatel, coordinateL: self.coordinateL, coor: coor))}
                        
                    }
                    
                    
                    count += 1
                    
                    print("\(Arr)")
                }

                if Arr.count == count {
                    
                    let lat = locationManager.location!.coordinate.latitude
                    let lon = locationManager.location!.coordinate.longitude
                    let coor = CLLocation(latitude: lat, longitude: lon)
                    
                    if OneDistances(coordinatel: self.coordinatel, coordinateL: self.coordinateL, coor: coor)  < 3*self.Radius{
                    
                let imageStr = profiles[value].imageName
                let docRef = db.collection("Coordinates").document("\(count + 1 )")
                docRef.setData(["coordinate": GeoPoint(latitude: self.coordinatel , longitude: self.coordinateL),
                                "Pic": imageStr,
                                "DateCreated": NSDate().timeIntervalSince1970,
                               ])
                    
                    dismiss(animated: true, completion: nil)
                    } else {
                        
                        let alert = UIAlertController(title: "Alert", message: "You are a bit too far from this area", preferredStyle: .alert)
                        
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            dismiss(animated: true, completion: nil)
                          })
                        
                        alert.addAction(ok)
                        
                        self.present(alert, animated: true)
                        
                    }}
                
                
                else {
                    let alert = UIAlertController(title: "Alert", message: "This area has aleardy been covered", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        dismiss(animated: true, completion: nil)
                      })
                    
                    alert.addAction(ok)
                    
                    self.present(alert, animated: true)
                }

            }
        }
    }
    
    
    func OneDistances (coordinatel: Double, coordinateL: Double, coor: CLLocation) -> Double {

        let Point_ref = CLLocation(latitude: coordinatel, longitude: coordinateL)

        return coor.distance(from: Point_ref)/1000

    }

    

    

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension OptionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CloudsCollectionViewCell.identifier, for: indexPath) as! CloudsCollectionViewCell

        let profile = profiles[indexPath.row]
        cell.setup(with: profile)
        cell.contentView.backgroundColor = .systemFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath) {
        
        progButtonPressed(value: indexPath.row)
    }
    
}

extension OptionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = itemWidth(for: view.frame.width, spacing: LayoutConstant.spacing)

        return CGSize(width: width, height: LayoutConstant.itemHeight)
    }

    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 2

        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow

        return floor(finalWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: LayoutConstant.spacing, left: LayoutConstant.spacing, bottom: LayoutConstant.spacing, right: LayoutConstant.spacing)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.spacing
    }
}
