//
//  RootViewController.swift
//  Moody
//
//  Created by Carl on 2022/8/17.
//

import UIKit
import CoreData

class RootViewController: UIViewController {
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Moody"
        
        let listController = MoodListViewController()
        listController.managedObjectContext = managedObjectContext
        self.addChild(listController)
        self.view.addSubview(listController.view)
        listController.view.snp.makeConstraints { make in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 180, right: 0))
        }
        
        let cameraController = CameraViewController()
        cameraController.delegate = self
        self.addChild(cameraController)
        self.view.addSubview(cameraController.view)
        cameraController.view.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(self.view)
            make.height.equalTo(180)
        }
    }
}

extension RootViewController: CameraViewControllerDelegate {
    func didCapture(_ image: UIImage) {
        managedObjectContext.performChanges {
            _ = Mood.inset(into: self.managedObjectContext, image: image)
        }
    }
}
