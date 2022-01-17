//
//  ViewController.swift
//  GrouponHeader
//
//  Created by James Sedlacek on 1/16/22.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Constants
    private let closedHeaderHeight: CGFloat = 65
    private let openHeaderHeight: CGFloat = 130
    private let lowerLimit: CGFloat = 0
    private let upperLimit: CGFloat = 55 // openHeaderHeight - closedHeaderHeight
    
    // MARK: - Variables
    private var isHeaderOpen = true
    
    // MARK: - IBOutlets
    @IBOutlet weak var locationStackView: UIStackView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var searchBarView: UICardView!
    @IBOutlet weak var searchBarStackView: UIStackView!
    @IBOutlet weak var cartIcon: UIImageView!
    @IBOutlet weak var searchBarLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var searchBarTextLeading: NSLayoutConstraint!
    @IBOutlet weak var searchBarLocationStackViewLeading: NSLayoutConstraint!
    @IBOutlet weak var searchBarLocationStackView: UIStackView!
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setupGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        overrideUserInterfaceStyle = .dark
        openHeaderView()
    }
    
    // MARK: - Setup
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupGestures() {
        // locationStackView
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(locationStackViewTapped))
        locationStackView.addGestureRecognizer(locationTap)
        
        // searchBarView
        let searchBarTap = UITapGestureRecognizer(target: self, action: #selector(searchBarViewTapped))
        searchBarView.addGestureRecognizer(searchBarTap)
        
        // cartIcon
        let cartIconTap = UITapGestureRecognizer(target: self, action: #selector(cartIconTapped))
        cartIcon.addGestureRecognizer(cartIconTap)
    }
    
    // MARK: - Gesture Actions
    
    @objc private func locationStackViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let searchLocationVC = SearchLocationVC(nibName: "SearchLocationVC", bundle: nil)
        searchLocationVC.modalPresentationStyle = .fullScreen
        present(searchLocationVC, animated: true, completion: nil)
    }
    
    @objc private func searchBarViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let searchGrouponVC = SearchGrouponVC(nibName: "SearchGrouponVC", bundle: nil)
        searchGrouponVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(searchGrouponVC, animated: true)
    }
    
    @objc private func cartIconTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let cartVC = CartVC(nibName: "CartVC", bundle: nil)
        present(cartVC, animated: true, completion: nil)
    }

}

// MARK: - TableView

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceholderCell") else {
            return UITableViewCell()
        }
        return cell
    }
    
    // MARK: - DidScroll
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.y
        
        if offSet < lowerLimit && !isHeaderOpen {
            openHeaderView()
            return
        }

        if offSet > upperLimit && isHeaderOpen {
            closeHeaderView(offSet)
            return
        }
        
        if offSet < lowerLimit || offSet > upperLimit { return }
        
        updateHeader(with: offSet)
    }
    
    private func updateHeader(with offSet: CGFloat) {
        handleLocationStackView(offSet)
        handleBackgroundView(offSet)
        handleUserInterfaceStyle(offSet)
        handleCartIcon(offSet)
        handleSeparator(offSet)
        handleStatusBar(offSet)
        handleSearchBarText(offSet)
        handleHeaderHeight(offSet)
        view.layoutIfNeeded()
    }
    
    private func handleHeaderHeight(_ offSet: CGFloat) {
        headerViewHeight.constant = openHeaderHeight - offSet
    }
    
    private func handleLocationStackView(_ offSet: CGFloat) {
        let limit: CGFloat = 8
        if offSet > limit {
            locationStackView.alpha = 0
            return
        }
        
        let percentage: CGFloat = 1 - (offSet / limit)
        locationStackView.alpha = 1 * percentage
    }
    
    private func handleBackgroundView(_ offSet: CGFloat) {
        let percentage: CGFloat = 1 - (offSet / upperLimit)
        backgroundView.alpha = 1 * percentage
    }
    
    private func handleUserInterfaceStyle(_ offSet: CGFloat) {
        if offSet <= lowerLimit + (upperLimit / 4) {
            overrideUserInterfaceStyle = .dark
        }
        if offSet >= upperLimit - (upperLimit / 4) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    private func handleCartIcon(_ offSet: CGFloat) {
        if offSet <= lowerLimit + (upperLimit / 2) {
            cartIcon.tintColor = .white
        } else {
            cartIcon.tintColor = .black
        }
    }
    
    private func handleSeparator(_ offSet: CGFloat) {
        if offSet <= lowerLimit + (upperLimit / 2) {
            separatorView.backgroundColor = .clear
        } else {
            separatorView.backgroundColor = .opaqueSeparator.withAlphaComponent(0.5)
        }
    }
    
    private func handleStatusBar(_ offSet: CGFloat) {
        if offSet <= lowerLimit + 2 {
            navigationController?.navigationBar.barStyle = .default
        }
        if offSet >= upperLimit - 2 {
            navigationController?.navigationBar.barStyle = .black
        }
    }
    
    private func handleSearchBarText(_ offSet: CGFloat) {
        let leadingDistanceFromMiddle: CGFloat = (searchBarView.frame.width - searchBarStackView.frame.width) / 2
        
        if offSet > lowerLimit {
            // Handle the SearchBar Text Leading Constraint
            searchBarLabel.text = "Search"
            let leadingMinimum: CGFloat = 10
            let maxDistance: CGFloat = upperLimit / 2
            
            if offSet <= maxDistance {
                let increment = leadingDistanceFromMiddle / maxDistance
                let distance = leadingDistanceFromMiddle - (increment * offSet)
                if distance > leadingMinimum {
                    searchBarTextLeading.constant = distance
                }
            } else {
                // Handle SearchBar Location StackView
                let leadingDistanceFromMiddle = searchBarView.frame.width
                let increment = (leadingDistanceFromMiddle / 2) / maxDistance
                let distance = leadingDistanceFromMiddle - (increment * (offSet - maxDistance))
                searchBarLocationStackViewLeading.constant = distance
                searchBarLocationStackView.alpha = (offSet - maxDistance) / maxDistance
            }
        } else if offSet == lowerLimit {
            searchBarLocationStackView.alpha = 0
            searchBarLocationStackViewLeading.constant = searchBarView.frame.width
            searchBarLabel.text = "Search Groupon"
            searchBarTextLeading.constant = leadingDistanceFromMiddle
        }
    }
    
    private func closeHeaderView(_ offSet: CGFloat) {
        if offSet > upperLimit {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let self = self else { return }
                self.updateHeader(with: self.upperLimit)
                self.view.layoutIfNeeded()
            })
        } else {
            tableView.setContentOffset(CGPoint(x: 0, y: upperLimit), animated: true)
        }
        isHeaderOpen = false
    }
    
    private func openHeaderView() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self = self else { return }
            self.tableView.setContentOffset(.zero, animated: false)
            self.updateHeader(with: self.lowerLimit)
            self.view.layoutIfNeeded()
        })
        isHeaderOpen = true
    }
    
    // MARK: - DidEnd
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapBack(scrollView.contentOffset.y)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        snapBack(scrollView.contentOffset.y)
    }
    
    private func snapBack(_ offSet: CGFloat) {
        if offSet > upperLimit / 2 {
            closeHeaderView(offSet)
        } else {
            openHeaderView()
        }
    }
}

