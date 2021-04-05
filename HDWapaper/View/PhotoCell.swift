//
//  PhotoCell.swift
//  HDWapaper
//
//  Created by BAC Vuong Toan (VTI.Intern) on 2/24/21.
//

import UIKit
import SDWebImage

class PhotoCell: BaseCLCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgPhoto: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        initComponent()
    }
    func initComponent(){
        imgPhoto.layer.cornerRadius = 8
        imgPhoto.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imgPhoto.layer.borderWidth = 0.5
        
    }
    func setUpCell(data: Photo) {
        lbTitle.text = data.title
        imgPhoto.sd_setImage(with: URL(string: data.url_l), completed: nil)
    }
}
