//
//  ViewController.swift
//  HDWapaper
//
//  Created by BAC Vuong Toan (VTI.Intern) on 2/24/21.
//

import UIKit
import ESPullToRefresh

class ViewController: UIViewController {
    @IBOutlet weak var navigationview: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var model: Flickr?
    var data: [Photo] = []
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(
        top: 20.0,
        left: 15.0,
        bottom: 20.0,
        right: 15.0)
    
    var page = 1

   

    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
        initData()
      }
    
    func initComponent(){
        collectionView.delegate = self
        collectionView.dataSource = self
        configureListRequest()
        customsNavigationView()
        PhotoCell.registerCellByNib(collectionView)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
        }
    }

    func initData() {
        fetchFilms { (model) in
            self.model = model
            self.data = model.photos.photo 
            if self.data.isEmpty{
                self.refresh()
                self.showAlert()
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func configureListRequest() {
        self.collectionView.es.addPullToRefresh {[unowned self] in
            self.refresh()
            self.collectionView.es.stopPullToRefresh()
        }

        self.collectionView.es.addInfiniteScrolling {[unowned self] in
            self.loadMore()
            self.collectionView.es.stopLoadingMore()
        }
    }
    
    func customsNavigationView() {
        navigationview.layer.masksToBounds = false
        navigationview.layer.shadowRadius = 4
        navigationview.layer.shadowOpacity = 1
        navigationview.layer.shadowColor = UIColor.gray.cgColor
        navigationview.layer.shadowOffset = CGSize(width: 0 , height:2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func showAlert(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Thông báo ", message: "Đang ở cuối trang", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    

    func fetchFilms(completionHandler: @escaping (Flickr) -> Void) {
        let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.favorites.getList&api_key=f7a259ccf01293370e8cd8d754cb6aa4&user_id=184865006%40N08&extras=views%2C%20url_l&per_page=50&page=\(page)&format=json&nojsoncallback=1")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
            print("Error with fetching films: \(error)")
            return
          }

          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
            print("Error with the response, unexpected status code: \(response)")
            return
          }

          if let data = data,
            let filmSummary = try? JSONDecoder().decode(Flickr.self, from: data) {
            completionHandler(filmSummary)
          }
        })
        task.resume()
      }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath as IndexPath) as! PhotoCell
        cell.setUpCell(data: data[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailImageController") as? DetailImageController
        vc?.setUpData(data: data[indexPath.row])
        print(data[indexPath.row])
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//            let availableWidth = view.frame.width - paddingSpace
//            let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: collectionView.bounds.width / 2 - 15, height: 200)
    }
    


}

extension ViewController {
    private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            self.page -= 1
            initData()
        }
    }

    private func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            self.page += 1
            initData()
        }
    }
}
