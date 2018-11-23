//
//  GuideView.swift
//  EOS
//
//  Created peng zhu on 2018/11/8.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import SnapKit

@IBDesignable
class GuideView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var pageControl: UIPageControl!

    var itemViews: [GuideContentView] = []

    func setup() {
        setupUI()
        updateSize()
    }

    func setupUI() {
        let data: [GuideModel] = pageData()
        for index in 0..<data.count {
            let item = data[index]
            let guideFrame = CGRect(x: self.width * index.cgFloat, y: 0, width: self.width, height: self.height - 44)
            let guideView = GuideContentView.init(frame: guideFrame)
            guideView.adapterModelToGuideContentView(item)
            itemViews.append(guideView)
            scrollView.addSubview(guideView)
        }
        scrollView.contentSize = CGSize(width: data.count.cgFloat * self.width, height: self.height)
    }

    func loadPageViews() {

    }

    func pageData() -> [GuideModel] {
        return [GuideModel.init(image: R.image.img_page_1(),
                                title: R.string.localizable.entry_guide_title_one.key.localized(),
                                subTitle: R.string.localizable.entry_guide_intro_one.key.localized()),
                GuideModel.init(image: R.image.img_page_2(),
                                title: R.string.localizable.entry_guide_title_two.key.localized(),
                                subTitle: R.string.localizable.entry_guide_intro_two.key.localized()),
                GuideModel.init(image: R.image.img_page_3(),
                                title: R.string.localizable.entry_guide_title_three.key.localized(),
                                subTitle: R.string.localizable.entry_guide_intro_three.key.localized())]
    }

    func pageViewWithModel(_ index: Int, model: GuideModel) -> GuideContentView {
        let pageView = GuideContentView()
        pageView.adapterModelToGuideContentView(model)
        return pageView
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        updateSize()
    }

    func updateSize() {
        for index in 0..<itemViews.count {
            let itemView = itemViews[index]
            let guideFrame = CGRect(x: self.width * index.cgFloat, y: 0, width: self.width, height: self.height - 44)
            itemView.frame = guideFrame
        }
        scrollView.contentSize = CGSize(width: itemViews.count.cgFloat * self.width, height: self.height - 44)
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
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        insertSubview(view, at: 0)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

extension GuideView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var index = 0
        let pageWidth = UIScreen.main.bounds.size.width
        index = lroundf(Float(scrollView.contentOffset.x / pageWidth.floor))
        pageControl.currentPage = index
    }
}
