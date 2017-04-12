//
//  ItemExtension.swift
//  DreamLister
//
//  Created by Danil on 28.02.17.
//  Copyright © 2017 VoitenkoDaniel. All rights reserved.
//

import UIKit
import CoreData

enum SortValue: Int {
    case sortByDate = 0
    case sortByPrice
    case sortByTitle
    case sortByType
}

extension Item {
    
    public override func awakeFromInsert() {
        self.created = NSDate()
    }
    
    class func saveItem(item:Item?, title: String?, price:String?, details: String?, pic:UIImage?, type:ItemType?, store:ItemStore?) {
        var newItem: Item
        if item != nil {
            newItem = item!
        } else {
            newItem = Item(context: context)
        }
        if title != nil {
            newItem.title = title
        }
        if price != nil {
            let newPrice = price! as NSString
            newItem.price = newPrice.doubleValue
        }
        if details != nil {
            newItem.details = details
        }
        if type != nil {
            newItem.toType = type
        }
        if store != nil {
            newItem.toStore = store
        }
        newItem.toImage = Item.createItemImage(image: pic)
        
        appDelegate.saveContext()
    }
    
    class func createItemImage(image:UIImage?) ->  Image{
        let newItemImage = Image(context: context)
        if image != nil {
            newItemImage.image = image
        }
        return newItemImage
    }
}

