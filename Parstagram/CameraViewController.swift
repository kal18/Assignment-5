//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Kimberly Le on 10/4/20.
//

import UIKit
import AlamofireImage
import Parse
 //UIImagePickerControllerDelegate allows for the code to know the camera events
 //so it will come back to a function (onCameraButton) that will give it the image it is looking for
class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentField: UITextField!
    
    @IBAction func onSubmitField(_ sender: Any) {
        let post = PFObject(className: "Posts") //pet is a like a dictionary
        post["caption"] = commentField.text
        post["author"] = PFUser.current()! //PFUser.current()! is the current person/self logged in
        //PF objects support default types plus binary objects such as photos which are actually stored as URLs so we have to create a separate thing called an "image data"
        
        /* saved in a separate table for photos*/
        let imageData = imageView.image!.pngData() //the reduced image from earlier is now being stored
        let file = PFFileObject(data: imageData!) //creating a new parse file
        /* saved in a separate table for photos*/
        
        
        post ["image"] = file //contains url to the image
        //it has not saved it yet so now we need to save this info
        
        post.saveInBackground { (success, error) in
            if success
            {
                //dismiss the view to choose pictures
                self.dismiss(animated: true, completion: nil)
                print("saved!")
            }
            else
            {
                print("error!")
            }
        }
    }
    //when the image is tapped we want this function to run
    @IBAction func onCameraButton(_ sender: Any) {
        /*easy way to do this*/
        //launching the camera
        let picker = UIImagePickerController()
        picker.delegate = self //when the user is done taking a picture, let the UIPickercontroller know what that image is and so it will call the function that holds the image
        picker.allowsEditing = true //presents second screen to the user to allow them to tweek the photo before posting it
        
        //check to see if the cam is available otherwise it will crash
        if UIImagePickerController.isSourceTypeAvailable(.camera) //this is a swift enum, usually starts with '.' and will figure it out based on context
        {
            picker.sourceType = .camera //if you're running on a real phone then it will use your camera
        }
        else
        {
            //if it runs on simulator, the camera cannot be accessed
            picker.sourceType = .photoLibrary
        }

        present(picker, animated: true, completion: nil) //upon tapping the camera button it will present the photo album
        /*easy way to do this but not easily configurable*/
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage //image comes inside a dictionary called info
        //once we have the image, we want to resize it, so now this is where importing alamofireimage on top is necessary
        
        //now to resize
        let size = CGSize(width: 300, height: 300) //resize the height and width
        let scaledImage = image.af.imageScaled(to: size) //scaling the image
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
