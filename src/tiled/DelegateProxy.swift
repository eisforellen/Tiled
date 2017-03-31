//
//  DelegateProxy.swift
//  tiled
//
//  Created by Benjamin de Jager on 12/10/15.
//  Copyright © 2015 Benjamin de Jager. All rights reserved.
//

import UIKit

class DelegateProxy: NSObject, UIScrollViewDelegate {
  weak var userDelegate: UIScrollViewDelegate?
  
  override func responds(to aSelector: Selector) -> Bool {
    return super.responds(to: aSelector) || userDelegate?.responds(to: aSelector) == true
  }
  
  override func forwardingTarget(for aSelector: Selector) -> Any? {
    if userDelegate?.responds(to: aSelector) == true {
      return userDelegate
    }
    else {
      return super.forwardingTarget(for: aSelector)
    }
  }
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    guard let scrollView = scrollView as? TilingScrollView else { return nil }
    return scrollView.viewForZooming(in: scrollView)
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    scrollView.didScroll()
//    _userDelegate?.scrollViewDidScroll?(scrollView)
  }

}
