//
//  MapDataCell.swift
//  googleMapsSDK
//
//  Created by RaveBizz on 2/18/21.
//

import UIKit

class MapDataCell: UICollectionViewCell {

    var deleteClosure: (() -> Void)?
    
    static let identifier = String(describing: MapDataCell.self)
    
    weak var text: UILabel!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var snippet: UILabel!
    @IBOutlet weak var coordinates: UILabel!
    @IBAction func deleteCell(_ sender: Any) {
        deleteClosure?()
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
