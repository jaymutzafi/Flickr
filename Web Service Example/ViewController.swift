//
//  ViewController.swift
//  Web Service Example
//
//  Created by Jay Mutzafi on 11/15/16.
//  Copyright © 2016 Paradox Apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var retrivedImages: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
//        self.view.addSubview(activityIndicator)
//        activityIndicator.center = view.center
//        activityIndicator.startAnimating()
        
//        searchFlickrBy(searchTerm: "dogs")
        
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        searchBar.resignFirstResponder()
        
        if searchBar.text != nil {
            searchFlickrBy(searchTerm: searchBar.text!)
        }
    }
    
    func searchFlickrBy(searchTerm: String) {
        
        let manager = AFHTTPSessionManager()
        
        let searchParameters:[String:Any] = ["method": "flickr.photos.search",
                                             "api_key": "866929c00b2f885ed9abf5947181a2a9",
                                             "format": "json",
                                             "nojsoncallback": 1,
                                             "text": searchTerm,
                                             "extras": "url_m",
                                             "per_page": 5]
        
        manager.get("https://api.flickr.com/services/rest/",
                    parameters: searchParameters,
                    progress: nil,
                    success: { (operation: URLSessionDataTask, responseObject:Any?) in
                        if let responseObject = responseObject {
                            print("Response: " + (responseObject as AnyObject).description)
                            
                            let json = JSON(responseObject)
                            if let photos = json["photos"]["photo"].array {
                                for photo in photos {
                                    if let url = photo["url_m"].string {
                                        if self.retrivedImages == nil {
                                            self.retrivedImages = [url]
                                        } else {
                                            self.retrivedImages?.append(url)
                                        }
                                    }
                                }
                            }
                            
                        }
                        
                        if let numberOfImages = self.retrivedImages?.count {
                            let deviceWidth = self.view.frame.width
                            self.scrollView.contentSize = CGSize(width: deviceWidth, height: 320 * CGFloat(numberOfImages))
                            
                            var i = 0
                            
                            for image in self.retrivedImages! {
                                
                                
                                // let imageData = NSData(contentsOf: url!)
                                // let retrivedImage = UIImage(data: imageData as! Data)
                                let imageView = UIImageView(frame: CGRect(x: 0, y: 320 * CGFloat(i), width: deviceWidth, height: 320))
                                imageView.contentMode = UIViewContentMode.scaleAspectFill
                                i += 1
                                if let url = URL(string: image) {
                                    imageView.setImageWith(url)
                                }
                                self.scrollView.addSubview(imageView)
                            }
                        }
                        
        }) { (operation:URLSessionDataTask?, error:Error) in
            print("Error: " + error.localizedDescription)
        }
    }


}

