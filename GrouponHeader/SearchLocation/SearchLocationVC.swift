//
//  SearchLocationVC.swift
//  GrouponHeader
//
//  Created by James Sedlacek on 1/16/22.
//

import UIKit

class SearchLocationVC: UIViewController {

    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    @IBAction func xmarkTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
    }

}
