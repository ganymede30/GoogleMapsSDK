//
//  SecondVC.swift
//  urlSessionPractice
//
//  Created by RaveBizz on 2/13/21.
//

import UIKit
import CoreData

class SecondVC: UIViewController, CanCreateSelf {

    var storyboardCoordinator: StoryboardCoordinator?
    var userModel: UserModel?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items:[MapData]?
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var snippetTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        collectionView.backgroundColor = .cyan
        updateLabels()
        configureTextFields()
        configureTapGesture()
        configureCollectionView()
        findAllMapData()
    }
    
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: MapDataCell.identifier, bundle: nil), forCellWithReuseIdentifier: MapDataCell.identifier)
    }
    
    private func configureTextFields(){
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
        titleTextField.delegate = self
        snippetTextField.delegate = self
    }
    
    private func configureTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func deleteAllCells(_ sender: Any) {
        deleteAll()
    }

    @IBAction func coreDataSubmit(_ sender: Any) {
        view.endEditing(true)
        createMapData(latitude: latitudeTextField.text!,
                      longitude: longitudeTextField.text!, title: titleTextField.text!, snippet: snippetTextField.text!)
        findAllMapData()
        updateTextFields()
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    
    func updateLabels(){
        userLabel.text = userModel?.user
        destinationLabel.text = userModel?.destination
    }
    
    func updateTextFields(){
        latitudeTextField.text = ""
        longitudeTextField.text = ""
        titleTextField.text = ""
        snippetTextField.text = ""
    }
}

extension SecondVC {
    
    func saveDatabase() {
        do {
            try self.context.save()
        } catch {
            print("Error saving to DB \(error)")
        }
    }
    
    func createMapData(latitude: String, longitude: String, title: String, snippet: String){
        let mapData = MapData(context: self.context)
        mapData.latitude = Double(latitude)!
        mapData.longitude = Double(longitude)!
        mapData.title = title
        mapData.snippet = snippet
        saveDatabase()
        collectionView.reloadData()
    }
    
    func findAllMapData(){
        do {
            self.items = try context.fetch(MapData.fetchRequest())
        } catch {
            print("Error fetching from DB \(error)")
        }
    }
    
    func deleteCell(cell: NSManagedObject){
        self.context.delete(cell)
        findAllMapData()
        collectionView.reloadData()
    }
    
    func deleteAll() {
        let request: NSFetchRequest<NSFetchRequestResult> = MapData.fetchRequest()
        let batchRequest = NSBatchDeleteRequest(fetchRequest: request)
        try? AppDelegate.viewContext.execute(batchRequest)
        findAllMapData()
        collectionView.reloadData()
    }

}

extension SecondVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapDataCell.identifier, for: indexPath) as? MapDataCell else { return UICollectionViewCell() }
        let indexItem = self.items?[indexPath.row]
        cell.backgroundColor = .clear
        cell.title.text = indexItem?.title!
        cell.snippet.text = indexItem?.snippet!
        cell.coordinates.text = "(\(indexItem?.latitude ?? 0), \( indexItem?.longitude ?? 0))"
        cell.deleteClosure = {
            self.deleteCell(cell: indexItem!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.size.width
        let numberOfCellsPerRow = 1
        let oddEven = indexPath.row / numberOfCellsPerRow % 2
        let dimensions = CGFloat(Int(totalWidth) / numberOfCellsPerRow)
        if (oddEven == 0) {
            return CGSize(width: dimensions/2.5, height: dimensions/2.5)
        } else {
            return CGSize(width: dimensions/2.5, height: dimensions/2.5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension SecondVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
