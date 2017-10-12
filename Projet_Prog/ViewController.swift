//
//  ViewController.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 11/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    var didSetupConstraints = false
    
    var containerView = ViewWithShadowNCornerRadius()
    
    var imageView = imageViewWithRoundCorner()
    
    let tableView = AddGameUITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.backgroundColor = .white
        
        imageView.image = UIImage(named: "profilePicture")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        
        self.view.addSubview(containerView)
        
        containerView.addSubview(imageView)
        containerView.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.reloadData()

        
        view.setNeedsUpdateConstraints()
        
    }
    
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            containerView.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view.snp.width).multipliedBy(0.9)
                make.height.equalTo(view.snp.height).multipliedBy(0.85)
                make.centerX.equalTo(view.snp.centerX)
                make.centerY.equalTo(view.snp.centerY).offset(30)
            }
            
            imageView.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(containerView.snp.width)
                make.height.equalTo(view.snp.height).multipliedBy(0.3)
                make.top.equalTo(containerView.snp.top)
                make.centerX.equalTo(containerView.snp.centerX)
            }
            
            tableView.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(containerView.snp.width)
                make.top.equalTo(imageView.snp.bottom)
                make.centerX.equalTo(containerView.snp.centerX)
                make.bottom.equalTo(containerView.snp.bottom).inset(10)
            }
            
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell?.textLabel?.text = "Cell \(indexPath.row)"
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 90
        }
        
        return 40
    }
    
}


class ViewWithShadowNCornerRadius: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cornerRadius = CGFloat(10)
        
        self.layer.cornerRadius = cornerRadius
        
        self.addShadow(offset: CGSize(width: 0, height: 18.0), color: UIColor.black, radius: 15, opacity: 0.1)
        
    }
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        
        let layer = self.layer
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        //Optional, to improve performance:
        layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
        layer.shouldRasterize = true
        
        let backgroundCGColor = self.backgroundColor?.cgColor
        self.backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}

class imageViewWithRoundCorner: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addCornerRadiusTop()
    
    }
    
    func addCornerRadiusTop() {
        let maskLayer = CAShapeLayer()
        
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:[.topLeft, .topRight],
                                cornerRadii: CGSize(width: 10, height:  10))
        
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        
    }
}


