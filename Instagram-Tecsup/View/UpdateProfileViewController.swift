//
//  UpdateProfileViewController.swift
//  Instagram-Tecsup
//
//  Created by MAC31 on 4/11/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class UpdateProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    
  
    @IBOutlet weak var txtBio: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    /// Pa poder acceder a la galeria o camara debemos de instanciar a UIImagePickerController
    let imagePicker = UIImagePickerController()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageProfile.layer.cornerRadius = 50
        getCurrentUser()
        setUpImagePicker()
        getUserDocument()
        // Do any additional setup after loading the view.
    }
    
    ///Obteniendo los datos actuales de user
    
    func getCurrentUser(){
        let user = Auth.auth().currentUser
        txtEmail.text = user?.email
        txtName.text = user?.displayName
    }
    
    func setUpImagePicker(){
        imagePicker.delegate = self
    }
    
    ///Guardando la da de user
    
    func saveUserData(url: String){
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "no-id").setData([
            "name": txtName.text!,
            "email": txtEmail.text!,
            "username": txtUsername.text!,
            "bio": txtBio.text!,
            "image": url
        ])
    }
    
    
    func imageFromURL(url: String){
        let imageURL = URL(string: url)
        let data = try? Data(contentsOf: imageURL!)
        
        if let imageData = data {
            imageProfile.image = UIImage(data: imageData)
            imageProfile.contentMode = .scaleAspectFill
        }
    }
    
    func getUserDocument(){
        let user = db.collection("users").document(Auth.auth().currentUser?.uid ?? "no-id")
        user.getDocument{ document, error in
            if error == nil {
                //Todo esta bien
                let data = document?.data()
                self.txtBio.text = data!["bio"] as? String
                self.txtName.text = data!["name"] as? String
                self.txtEmail.text = data!["email"] as? String
                self.txtUsername.text = data!["username"] as? String
                self.imageFromURL(url: data!["image"] as? String ?? "")
            }
        }
    }
    
    @IBAction func onTapBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        
    }
    @IBAction func onTapSaveData(_ sender: UIButton) {
        uploadImage()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapOpenGallery(_ sender: UIButton) {
        imagePicker.isEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true)
    }
}

extension UpdateProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func uploadImage(){
        let storaRef = Storage.storage().reference().child("\(Auth.auth().currentUser?.uid ?? "").png")
        
        if let uploadDataImage = self.imageProfile.image?.jpegData(compressionQuality: 0.5){
            storaRef.putData(uploadDataImage){
                metadata, error in
                if error == nil{
//                    Esta bien, vamos obtener la URL de la foto
                    storaRef.downloadURL{
                        url, error in print(url?.absoluteString)
                        self.saveUserData(url: url?.absoluteString ?? "")
                    }
                }else{
                    print("Error \(error)")
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[.originalImage] as? UIImage{
            imageProfile.image = pickerImage
            imageProfile.contentMode = .scaleToFill
        }
        
        imagePicker.dismiss(animated: true)
    }
    
}
