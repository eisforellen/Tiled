//
//  TilingImageView.swift
//  tiledviewer
//
//  Created by Benjamin de Jager on 12/5/14.
//  Copyright (c) 2014 Q42. All rights reserved.
//

import UIKit

open class TilingImageView: UIImageView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  var thumbUrl: URL! {
    didSet {
      let urlSession = URLSession()
      urlSession.dataTask(with: thumbUrl, completionHandler: { (data, response, error) in
        guard error != nil else {
          print("failed fetching thumb")
          return
        }

        self.contentMode = UIViewContentMode.scaleAspectFit
        self.image = UIImage(data: data!)
      }) 
    }
  }
}
