//
//  CaptureImageViewController.swift
//  SDKSampleApp
//
//  Created by davix on 10/31/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//
import UIKit
import Foundation
import EZLoadingActivity

@objc class CaptureImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet var imageView: UIImageView!
    
    var connected : Bool = false
    
    class func newInstance() -> CaptureImageViewController{
        return CaptureImageViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presentCamera()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func takeAnotherImageButtonClicked(_ sender: Any) {
        self.presentCamera()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imagePickerController(picker, pickedImage: image)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
        self.imageView.image = pickedImage
        self.applyFilterForDemo(imgData: self.getImageData())
        self.imageView.image = self.getImgFromSDK()!
        self.persistImgToDisk(image: self.imageView.image!)
        dismiss(animated: true, completion: nil)
    }
    
    func persistImgToDisk(image : UIImage){
        let helper = ImageSavingHelper()
        helper.saveImage(image: image)
    }
    
    func presentCamera(){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func applyFilterForDemo(imgData : Data){
        
        var errorPtr : NSError?
        let imageHelper = CSSImageHelper.init()
        imageHelper.load(fromBytes: imgData, error: &errorPtr)
        self.applyDarkerFilter()
        self.applyBlackAndWhiteFilter()
    }
    
    func applyDarkerFilter(){
        
        let filterNames : [Any] = [CMSFilterBrightness]
        let parameters : [AnyHashable : Any] = [NSNumber.init(value: -16) : CMSFilterParamBrightnessScale]
        CMSCaptureImage.applyFilters(filterNames, parameters: parameters)
    }
    
    func applyBlackAndWhiteFilter(){
        
        let filterNames : [Any] = [CMSFilterAdaptiveBinary]
        let parameters : [AnyHashable : Any] = [CMSFilterParamAdaptiveBinaryForce: CSSSettings.bool(forKey: "FilterForce"),CMSFilterParamAdaptiveBinaryBlackness: CSSSettings.integer(forKey: "FilterBlackness")]
        CMSCaptureImage.applyFilters(filterNames, parameters: parameters)
        
    }
    
    func getImgFromSDK() -> UIImage? {
        
        var sdkImg : UIImage? = nil
        do{
            let imageData = try CMSCaptureImage.encode(forFormat: CMSSaveJpg, parameters: nil)
            sdkImg = UIImage.init(data: imageData)
        }
        catch{
            
        }
        return sdkImg
    }
    
    func getImageData() -> Data {
        
        let img = self.imageView.image
        let data = UIImageJPEGRepresentation(img!, 1.0)
        return data!

    }

    @IBAction func uploadPodBtnClicked(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "uploadImageView") as! UploadImageViewController
        vc.connected = self.connected
        let navigationController = self.navigationController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

