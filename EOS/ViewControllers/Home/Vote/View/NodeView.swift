//
//  NodeView.swift
//  EOS
//
//  Created by peng zhu on 2018/8/8.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

class NodeView: UIView {
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
        
    @IBOutlet weak var perLabel: UILabel!
    
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var ownerLabel: UILabel!
    
    @IBOutlet weak var urlLabel: UILabel!
    
    func setup() {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setup()
    }
    
    fileprivate func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib.init(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}

extension NodeView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.backgroundColor = UIColor.paleGrey41
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.backgroundColor = UIColor.whiteTwo
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        self.backgroundColor = UIColor.paleGrey41
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.backgroundColor = UIColor.whiteTwo
    }
}
