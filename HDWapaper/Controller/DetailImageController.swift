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
    @IBOutlet weak var btnDownload: UIButton!
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
        self.btnDownload.layer.cornerRadius = btnDownload.bounds.size.height/2

    }
    
    func setUpData(data: Photo) {
        self.model = data
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDownload(_ sender: Any) {
        downloadImage(url: model?.url_l ?? "")
    }
}

extension DetailImageController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
extension DetailImageController {
    func downloadImage(url: String) {
        guard let imageUrl = URL(string: url) else { return }
        getDataFromUrl(url: imageUrl) { data, _, _ in
            DispatchQueue.main.async() {
                let activityViewController = UIActivityViewController(activityItems: [data ?? ""], applicationActivities: nil)
                activityViewController.modalPresentationStyle = .fullScreen
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }

    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
}




