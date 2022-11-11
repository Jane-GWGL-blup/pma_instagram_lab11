//
//  LoginViewController.swift
//  Instagram-Tecsup
//
//  Created by MAC31 on 21/10/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.isSecureTextEntry = true

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkSession()
    }
    
    func checkSession(){
        if Auth.auth().currentUser != nil{
        ///Si el current existe entonces tenemos session de usuario
        self.performSegue(withIdentifier: "seguelogin", sender: nil)
        }
    }

    @IBAction func onTapLogin(_ sender: UIButton) {
        if txtEmail.text == "" || txtPassword.text == "" {
            let alert = UIAlertController(title: "Error", message: "Completa los campos", preferredStyle: .alert)
            let alertButton = UIAlertAction(title: "ok", style: .default)
            alert.addAction(alertButton)
            present(alert, animated: true)
            return
        }
        signIn(email: txtEmail.text!, password: txtPassword.text!)
    }
    ///Vamos a crear 2 funciones: registro y para el sign
    ///Si el usuario no existe llamo registro
    func signIn(email:String, password:String){
        Auth.auth().signIn(withEmail: email, password: password) {
            authResult, error in
//            error es la variable donde si un error tendra valor, si error no tiene un valor entendemos
//            que todo esta bien por ende error es igual a nil
            if error == nil {
                ///El usuario existe
                self.performSegue(withIdentifier:  "seguelogin", sender: nil)
            } else {
                ///El usuario no existe
                self.signUp(email: email, password: password)
            }
        }
    }
    
    func signUp(email: String, password:String){
        Auth.auth().createUser(withEmail: email, password: password){
            authResult, error in
            
            if error != nil {
//                Vamnos a crear la alerta
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
//                Agregando un boton
                let alertButton = UIAlertAction(title: "ok", style: .default)
                alert.addAction(alertButton)
            }else{
//                Se creo el usuario
                self.performSegue(withIdentifier: "seguelogin", sender: nil)
                }
            }
        }
}
