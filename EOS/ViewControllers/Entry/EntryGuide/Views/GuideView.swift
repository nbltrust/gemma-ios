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
class GuideView: BaseView {

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var pageControl: UIPageControl!

    @IBOutlet weak var pageView1: GuideContentView!
    
    @IBOutlet weak var pageView2: GuideContentView!
    
    @IBOutlet weak var pageView3: GuideContentView!

    override func setup() {
        super.setup()
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        pageView1.adapterModelToGuideContentView(pageData()[0])
        pageView2.adapterModelToGuideContentView(pageData()[1])
        pageView3.adapterModelToGuideContentView(pageData()[2])
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

    func setupSubViewEvent() {

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
