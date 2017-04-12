//
//  DetailsVC.swift
//  DreamLister
//
//  Created by Danil on 01.03.17.
//  Copyright © 2017 VoitenkoDaniel. All rights reserved.
//

import UIKit
import CoreData

class DetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: IBOutlets
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var priceTextField: CustomTextField!
    @IBOutlet weak var detailTextField: CustomTextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var editItem: Item?
    var stores = [ItemStore]()
    var types = [ItemType]()
    var imagePicker: UIImagePickerController!
    
    var selectedType: ItemType?
    var selectedStore: ItemStore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if editItem != nil {
            titleTextField.text = editItem!.title
            priceTextField.text = "\(editItem!.price)"
            detailTextField.text = editItem!.details
            if editItem?.toImage != nil, editItem?.toImage?.image != nil {
                
                itemImageView.image = editItem?.toImage?.image as! UIImage?
            }
        }
        if editItem != nil {
            
        }
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        fillStores()
    }
    
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let test = info["UIImagePickerControllerOriginalImage"] as! UIImage
        itemImageView.image = test
        print(test)
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return stores.count
        } else if component == 1{
            return types.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let store = stores[row]
            return store.title!
        } else if component == 1 {
            let type = types[row]
            return type.type!
        } else {
            return ""
        }
    }
    
    //MARK:UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedStore = stores[row]
        } else if component == 1 {
            selectedType = types[row]
        }
    }
    
    //MARK: IBActions
    @IBAction func actionImagePressed(_ sender: UIControl) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func actionTrashButtonPressed(_ sender: UIBarButtonItem) {
        if editItem != nil {
            context.delete(editItem!)
            appDelegate.saveContext()
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func actionSaveButtonPressed(_ sender: UIButton) {
        DispatchQueue.global().async {
         Item.saveItem(item: self.editItem,
                       title: self.titleTextField.text,
                       price: self.priceTextField.text,
                       details: self.detailTextField.text,
                       pic: self.itemImageView.image,
                       type: self.selectedType,
                       store: self.selectedStore)
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    func fillStores() {
        let storeRequest: NSFetchRequest<ItemStore> = ItemStore.fetchRequest()
        let typeRequest:NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do {
            stores = try context.fetch(storeRequest)
            self.types = try context.fetch(typeRequest)
            self.pickerView.reloadAllComponents()
        } catch {
            let error = error as NSError
            print(error)
        }
        
        
    }
}
