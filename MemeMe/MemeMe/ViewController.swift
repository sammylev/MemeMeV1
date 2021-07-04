//
//  ViewController.swift
//  MemeMe
//
//  Created by Sammy Murray on 6/20/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UIToolbar!
    
    
    let topText = memeTextFieldDelegate()
    let bottomText = memeTextFieldDelegate()
    var meme: Meme!
    var memedImage = UIImage()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTextFields()
        shareButton.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    // User selected the button to select an existing image from album.
    @IBAction func pickAnImage(_ sender: Any) {
        loadImage(sourceType: .photoLibrary)
    }
    
    // User selected the button to use the camera to take a new picture
    @IBAction func takePicture(_ sender: Any) {
        loadImage(sourceType: .camera)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        share()
    }
    
    // Loading the image from either camera or album and enabling the share button
    func loadImage(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        shareButton.isEnabled = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func addTextFields() {
        self.topTextField.delegate = self.topText
        self.bottomTextField.delegate = self.bottomText
        
        topText.initializeText(topTextField, defaultText: "Top Text")
        bottomText.initializeText(bottomTextField, defaultText: "Bottom Text")
    }
    
    
    // User picked an image. App gets image data back
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            ImagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }

    // User hit cancel and didn't pick an image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // If keyboard will be showing, change the view to fit above keyboard
    @objc func keyboardWillShow(_ notification: Notification){
        view.frame.origin.y = -getKeyboardHeight(notification: notification as NSNotification)
    }
    
    // After the keyboard will be hidden, reset the view
    @objc func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
    
    // For the user's device, get the size of the keyboard so the view can be changed accordingly
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // Be notified of when the keyboard will show and hide
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // Stop being notified of when the keyboard will hide and show
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Create the meme
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: ImagePickerView.image!, completeMeme: memedImage)
        self.meme = meme
        
    }

    // Generate the meme image
    func generateMemedImage() -> UIImage {

        changeView(show: false)

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        changeView(show: true)

        return memedImage
    }
    
    // Hide or show the toolbars
    func changeView(show: Bool) {
        navBar.isHidden = !show
        toolBar.isHidden = !show
    }
    
    func share() {
        let memeShare = generateMemedImage()
        let shareVC = UIActivityViewController(activityItems: [memeShare], applicationActivities: nil)
        
        shareVC.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                self.save()
            }
        }
        present(shareVC, animated: true, completion: nil)
    }

}

