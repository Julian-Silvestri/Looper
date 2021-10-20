//
//  ViewController.swift
//  Looper
//
//  Created by Julian Silvestri on 2021-10-19.
//

import UIKit

class DynamicLooperCell: UICollectionViewCell{
    
}

class Main: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openingLogoAnimation()
    }
    
    //MARK: Opening Logo Animation
    func openingLogoAnimation(){
        UIView.animate(withDuration: 1, animations: {
            self.logo.frame = CGRect(x: 16, y: 20, width: 79, height: 82)

        })
    }
    
    //MARK: Number of rows in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    //MARK: Cell For Row At
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }

}

