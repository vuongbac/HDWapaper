//
//  DetailImageController.swift
//  HDWapaper
//
//  Created by BAC Vuong Toan (VTI.Intern) on 3/1/21.
//

import UIKit
import SDWebImage

class DetailImageController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    var model: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        imageView.sd_setImage(with: URL(string: self.model?.url_l ?? ""), completed: nil)
    }
    
    func initComponents(){
        scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
    }
    
    func setUpData(data: Photo) {
        self.model = data
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension DetailImageController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
