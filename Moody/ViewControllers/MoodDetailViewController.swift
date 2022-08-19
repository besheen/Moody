//
//  MoodDetailViewController.swift
//  Moody
//
//  Created by Carl on 2022/8/15.
//

import UIKit

class MoodDetailViewController: UIViewController {
    lazy var moodImageView: UIImageView = {
        let moodImageVew = UIImageView()
        moodImageVew.contentMode = UIView.ContentMode.scaleAspectFill
        moodImageVew.clipsToBounds = true
        return moodImageVew
    }()
    
    var mood: Mood! {
        didSet {
            observer = ManagedObjectObserver(object: mood) { [weak self] type in
                guard type == .delete else {
                    return
                }
                _ = self?.navigationController?.popViewController(animated: true)
            }
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.title = "Mood Detail"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash, target: self, action: #selector(deleteAction))
        
        view.addSubview(moodImageView)
        moodImageView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.height.equalTo(moodImageView.snp.width)
            make.centerY.equalTo(view)
        }
    }
    
    // MARK: Response action
    @objc func deleteAction() {
        mood.managedObjectContext?.performChanges {
            self.mood.managedObjectContext?.delete(self.mood)
        }
    }
    
    // MARK: Private
    fileprivate var observer: ManagedObjectObserver?
    
    fileprivate func updateViews() {
        moodImageView.image = UIImage(data: mood.imageData)
    }
}
