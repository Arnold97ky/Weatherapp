//
//  CloudsCollectionViewCell.swift
//  WeatherApp
//
//  Created by CHRISTIAN BEYNIS on 8/19/22.
//
import UIKit

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

class CloudsCollectionViewCell: UICollectionViewCell {
   
    private enum Constants {
        // MARK: contentView layout constants
        static let contentViewCornerRadius: CGFloat = 4.0

        // MARK: profileImageView layout constants
        static let imageHeight: CGFloat = 45

        // MARK: Generic layout constants
        static let verticalSpacing: CGFloat = 8.0
        static let horizontalPadding: CGFloat = 16.0
        static let profileDescriptionVerticalPadding: CGFloat = 8.0
    }

    private let profileImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

//    let name: UILabel = {
//        let label = UILabel(frame: .zero)
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        return label
//    }()
//
//    let locationLabel: UILabel = {
//        let label = UILabel(frame: .zero)
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        return label
//    }()
//
//    let professionLabel: UILabel = {
//        let label = UILabel(frame: .zero)
//        label.textAlignment = .center
//        return label
//    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupLayouts()
    }

    private func setupViews() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = Constants.contentViewCornerRadius
        contentView.backgroundColor = .systemFill

        contentView.addSubview(profileImageView)
        //contentView.addSubview(name)
        //contentView.addSubview(locationLabel)
        //contentView.addSubview(professionLabel)
    }

    private func setupLayouts() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        //name.translatesAutoresizingMaskIntoConstraints = false
        //locationLabel.translatesAutoresizingMaskIntoConstraints = false
        //professionLabel.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for `profileImageView`
        NSLayoutConstraint.activate([
            
            
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            //profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight)
        ])

 
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with profile: Profile) {
        profileImageView.image = UIImage(named: profile.imageName)
        //name.text = profile.name
        //locationLabel.text = profile.location
        //professionLabel.text = profile.profession
    }
}


extension CloudsCollectionViewCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
