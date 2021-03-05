//
//  ThirdVC.swift
//  urlSessionPractice
//
//  Created by RaveBizz on 2/13/21.
//

import UIKit
import GoogleMaps

class ThirdVC: UIViewController, CanCreateSelf {

    var storyboardCoordinator: StoryboardCoordinator?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items:[MapData]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        findAllMapData()
        createMap()
    }
    
    func findAllMapData(){
        do {
            self.items = try context.fetch(MapData.fetchRequest())
        } catch {
            print("Error fetching from DB \(error)")
        }
    }
    
    func createStoryView(mapView: GMSMapView){
        let rect = CGRect(x: 100, y: 100, width: 50, height: 50)
        let image = UIImage(systemName: "pencil")
        var imageView: UIImageView
        imageView = UIImageView(image: image)
        imageView.frame = rect
        mapView.addSubview(imageView)
    }
    
    func createMap(){
        let camera = createCamera()
        var mapView: GMSMapView
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.mapType = .satellite
        createStoryView(mapView: mapView)
        self.view.addSubview(mapView)
        items?.forEach(){
            addMarkers(mapView: mapView, latitude: $0.latitude, longitude: $0.longitude, title: $0.title ?? "No Title", snippet: $0.snippet ?? "No Snippet")
        }
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
//        marker.opacity = 0;
//        marker.infoWindowAnchor.y = 1
        marker.map = mapView
    }
    
}
//var iconView: UIImageView?
//let image = UIImage(systemName: "pencil")
//iconView = UIImageView(image: image)
//marker.iconView = iconView
