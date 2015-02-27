//
//  ViewController.swift
//  cropImageWithLib1
//
//  Created by Anil on 26/02/15.
//  Copyright (c) 2015 Variya Soft Solutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ImageCropViewControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!

    var imageCropView = ImageCropView()
    var image : UIImage? = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageCropView.image = UIImage(named: "2.jpg")
        self.imageCropView.controlColor = UIColor.cyanColor()
        
    }
    
    @IBAction func takeBarButtonClick(sender: AnyObject) {
        
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .Camera
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }else{
            
            var alert = UIAlertController(title: "Warning", message: "Your device doesn't have a camera.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func openBarButtonClick(sender: AnyObject) {
        
        var imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        self.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = self.image
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cropBarButtonClick(sender: AnyObject) {
        
        if self.image != nil{
            
            var controller = ImageCropViewController1(image: self.image)
            controller.delegate = self
            controller.blurredBackground = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func ImageCropViewController(controller: UIViewController!, didFinishCroppingImage croppedImage: UIImage!) {
        
        self.image = croppedImage
        self.imageView.image = self.image
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func ImageCropViewControllerDidCancel(controller: UIViewController!) {
        
        self.imageView.image = self.image
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func thisImage(image : UIImage, hasBeenSavedInPhotoAlbumWithError error : NSError?, usingContextInfo ctxInfo : ()){
        if let actualError = error {
            
            var alert = UIAlertController(title: "Fail!", message: "Saved with error \(actualError.description).", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }else{
            
            var alert = UIAlertController(title: "Succes!", message: "Saved to camera roll.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func saveBarButtonClick(sender: AnyObject) {
        
        if self.image != nil{
            
            UIImageWriteToSavedPhotosAlbum(self.image, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafePointer<()>) {
        dispatch_async(dispatch_get_main_queue(), {
            UIAlertView(title: "Success", message: "This image has been saved to your Camera Roll successfully", delegate: nil, cancelButtonTitle: "Close").show()
        })
    }
}

