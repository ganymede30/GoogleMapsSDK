//
//  FourthVC.swift
//  urlSessionPractice
//
//  Created by RaveBizz on 2/13/21.
//

import UIKit
import GoogleMaps


class FourthVC: UIViewController, CanCreateSelf {

    var storyboardCoordinator: StoryboardCoordinator?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items:[MapData]?
    
    weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findAllMapData()
        createMap()
        setUpCollectionView()
        configureCollectionView()
    }
    
    func findAllMapData(){
        do {
            self.items = try context.fetch(MapData.fetchRequest())
        } catch {
            print("Error fetching from DB \(error)")
        }
    }
    
    func createMap(){
        let camera = createCamera()
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.mapType = .satellite
        self.view.addSubview(mapView)
        items?.forEach(){
            addMarkers(mapView: mapView, latitude: $0.latitude, longitude: $0.longitude, title: $0.title ?? "No Title", snippet: $0.snippet ?? "No Snippet")
        }
        setUpCollectionViewConstraints(mapView: mapView)
    }
    
    func createCamera() -> GMSCameraPosition{
        let zoom: Float = 15.0
        let latitudeAverage = ((items?.reduce(0.0, {x, y in
            x + y.latitude
        }))!)/(Double(items!.count))
        let longitudeAverage = ((items?.reduce(0.0, {x, y in
            x + y.longitude
        }))!)/(Double(items!.count))
        return GMSCameraPosition.camera(withLatitude: latitudeAverage, longitude: longitudeAverage, zoom: zoom)
    }
    
    func addMarkers(mapView: GMSMapView, latitude: Double, longitude: Double, title: String, snippet: String){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = title
        marker.snippet = snippet
        marker.map = mapView
    }
    
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: MapDataCell.identifier, bundle: nil), forCellWithReuseIdentifier: MapDataCell.identifier)
    }

    func setUpCollectionView(){
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(MapDataCell.self, forCellWithReuseIdentifier: MapDataCell.identifier)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = .clear
    }
    
    func setUpCollectionViewConstraints(mapView: GMSMapView){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 10),
            collectionView.heightAnchor.constraint(equalTo: mapView.heightAnchor, multiplier: 0.2),
            collectionView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -10)
        ])
        self.collectionView = collectionView
    }  
}

extension FourthVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
}

extension FourthVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapDataCell.identifier, for: indexPath) as? MapDataCell else { return UICollectionViewCell() }
        let indexItem = self.items?[indexPath.row]
        print(indexItem as Any)
        cell.backgroundColor = .white
                cell.title.text = indexItem?.title!
                cell.snippet.text = indexItem?.snippet!
                cell.coordinates.text = "(\(indexItem?.latitude ?? 0), \( indexItem?.longitude ?? 0))"
        return cell
    }
}

extension FourthVC: UICollectionViewDelegateFlowLayout {
    private enum LayoutConstant {
        static let spacing: CGFloat = 16.0
        static let itemHeight: CGFloat = 300.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = itemWidth(for: view.frame.width, spacing: 0)
        
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 2
        
        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow
        
        return finalWidth - 5.0
    }
}
