//
//  TilingView.swift
//  tiledviewer
//
//  Created by Benjamin de Jager on 12/5/14.
//  Copyright (c) 2014 Q42. All rights reserved.
//

import UIKit
import QuartzCore

public protocol TilingViewDataSource {
  func tilingView(_ tilingView: TilingView, imageForColumn column: Int, andRow row: Int, forScale scale: CGFloat) -> UIImage?
}

open class TilingView: UIView {
  
  open var dataSource : TilingViewDataSource!
  open var levelsOfDetail : Int = 0 {
    didSet {
      let tiledLayer = self.layer as! CATiledLayer
      tiledLayer.levelsOfDetail = levelsOfDetail
    }
  }
  open var tileSize : CGSize = CGSize.zero {
    didSet {
      let tiledLayer = self.layer as! CATiledLayer
      tiledLayer.tileSize = tileSize
    }
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = UIColor.clear
  }
  
  // MARK: overrides
  
  override open func draw(_ rect: CGRect) {
    
    let context = UIGraphicsGetCurrentContext()
    
    let tiledLayer = self.layer as! CATiledLayer
    var tileSize = tiledLayer.tileSize
    
    // Even at scales lower than 100%, we are drawing into a rect in the coordinate system
    // of the full image. One tile at 50% covers the width (in original image coordinates)
    // of two tiles at 100%. So at 50% we need to stretch our tiles to double the width
    // and height; at 25% we need to stretch them to quadruple the width and height; and so on.
    // (Note that this means that we are drawing very blurry images as the scale gets low.
    // At 12.5%, our lowest scale, we are stretching about 6 small tiles to fill the entire
    // original image area. But this is okay, because the big blurry image we're drawing
    // here will be scaled way down before it is displayed.)
    
    let contextTransform = context?.ctm
    let scaleX = contextTransform?.a
    let scaleY = contextTransform?.d
    
    tileSize.width /= scaleX!
    tileSize.height /= -scaleY!
    
    // calculate the rows and columns of tiles that intersect the rect we have been asked to draw
    let firstCol = Int(floorf(Float(rect.minX / tileSize.width)))
    let lastCol = Int(floorf(Float(rect.maxX / tileSize.width)))
    let firstRow = Int(floorf(Float(rect.minY / tileSize.height)))
    let lastRow = Int(floorf(Float(rect.maxY / tileSize.height)))
    
    for row in firstRow...lastRow {
      for col in firstCol...lastCol {
        var tileRect = CGRect(x: tileSize.width * CGFloat(col), y: tileSize.height * CGFloat(row),
                              width: tileSize.width, height: tileSize.height)

        // if the tile would stick outside of our bounds, we need to truncate it so as
        // to avoid stretching out the partial tiles at the right and bottom edges
        tileRect = self.bounds.intersection(tileRect)
        if let tile = dataSource.tilingView(self, imageForColumn: col, andRow: row, forScale: scaleX!) {
          tile.draw(in: tileRect)
        }
      }
    }
    
  }
  
  override open class var layerClass : AnyClass {
    return CATiledLayer.self
  }
  
  override open var contentScaleFactor : CGFloat {
    didSet {
      super.contentScaleFactor = 1
    }
  }
  
}
