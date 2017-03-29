//
//  CapturaDeInformacion.swift
//  modulo8final
//
//  Created by Raymundo Peralta on 3/28/17.
//  Copyright © 2017 Raymundo Peralta. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData


class CapturaDeInformacion: UIViewController, UITextFieldDelegate {
    
    var telefono:String?
    @IBOutlet weak var contraseña: UITextField!
    @IBOutlet weak var confirmaContraseña: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var confirmaEMail: UITextField!
    
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    
    @IBAction func actionBtnFinalizar(sender: UIButton) {
        var contraseñaOK: Bool = false
        var emailOK: Bool = false
        
        print("Verificamos que las contraseñas coincidan")
        if ((contraseña.text == confirmaContraseña.text) && (contraseña.text?.characters.count == 4)) {
            contraseñaOK = true
            print("contraseñas coinciden")
        } else {
            // alerta al usuario
            print("contraseñas no coinciden")
            let alert = UIAlertController(title: "Alerta", message: "Las contraseñas no coinciden o no son válidas", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        print("Verificamos email")
        if (verificalEMail(email.text!) && (email.text == confirmaEMail.text) && (confirmaEMail.text?.characters.count >= 6)) {
            emailOK = true
            print("Email coincide")
        } else {
            // alerta al usuario
            print("Email no coincide")
            let alert = UIAlertController(title: "Alerta", message: "Los emails no coinciden o son invalidos", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        if (contraseñaOK && emailOK) {
            // Guardar la información en la base de datos
            print("Vamos a guardar la información en la base de datos")
            let managedContext = CoreDataStack.sharedInstance.managedObjectContext
            
            let entity = NSEntityDescription.entityForName("Usuarios", inManagedObjectContext: managedContext)
            
            let usuarios = Usuarios(entity: entity!, insertIntoManagedObjectContext: managedContext)
            
            usuarios.setValue(telefono, forKey: "telefono")
            usuarios.setValue(contraseña.text, forKey: "contrasena")
            usuarios.setValue(email.text, forKey: "correo")
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
            
            // Brincar a la primer pantalla
            self.performSegueWithIdentifier("IrPrimerPantalla1", sender: self)
            print("Nos vamos a la primer pantalla")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("CapturaDeInformación " + telefono!)
        
        contraseña.delegate = self
        confirmaContraseña.delegate = self
        email.delegate = self
        confirmaEMail.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CapturaDeInformacion.escondeTeclado))
        view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.apareceTeclado), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.desapareceTeclado), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func apareceTeclado(notification:NSNotification) {
        print("keyboard will show")
        ajustandoAltura(true, notification: notification)
    }
    
    func desapareceTeclado(notification:NSNotification) {
        print("keyboard will hide")
        ajustandoAltura(false, notification: notification)
    }
    
    func ajustandoAltura(show:Bool, notification:NSNotification) {
        
        let userInfo = notification.userInfo!
        
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        let changeInHeight = (CGRectGetHeight(keyboardFrame) + 40) * (show ? 1 : -1)
        
        backgroundScrollView.contentInset.bottom += changeInHeight
        
        backgroundScrollView.scrollIndicatorInsets.bottom += changeInHeight
        
    }
    
    func verificalEMail(emailAddr: String) -> Bool {
        // vamos a probar las expresiones regulares de swift
        // esta expresión debe definir una dirección de correo general
        // tiene una limitación no acepta una email de la forma a@b, etc
        // lo mas simple que acepta es de la forma a9@a.9
        let pat = "[a-zA-Z0-9][a-zA-Z0-9.\\-_]*[a-zA-Z0-9]@[a-zA-Z0-9][a-zA-Z0-9.]+[a-zA-Z0-9]"
        let nsString = emailAddr as NSString
        do {
            let regex = try NSRegularExpression(pattern: pat, options: [])
            let results = regex.matchesInString(emailAddr, options: [], range: NSMakeRange(0, nsString.length))
            //print(results.map { nsString.substringWithRange($0.range)}.count)
            if (results.map { nsString.substringWithRange($0.range)}.count > 0) {
                return results.map { nsString.substringWithRange($0.range)}[0] == emailAddr
            } else {
                return false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("TAG \(textField.tag)")
        // en cualquier caso si recibimos un delete key borramos un caracter
        if (range.length == 1 && string.isEmpty){
            print("tecleamos back space")
            print(textField.text!)
            print(string)
            print("------")
            print(textField.text?.characters.count)
            let result = String.init(textField.text!.characters.dropLast())
            print(result.characters.count)
            textField.text = result
            print(textField.text!)
            print(">>>>>>>>")
            return false
        }
        
        let nuevoTamaño = textField.text!.characters.count + string.characters.count - range.length
        //debug para ver el tamaño del nuevo texto
        print("nuevo tamaño " + String(nuevoTamaño))
        print("text visible " + textField.text!)
        
        switch (textField.tag) {
        case 1: // contraseña
            return nuevoTamaño <= 4
        case 2: // confirma contraseña
            return nuevoTamaño <= 4
        case 3: // email
            return true
        case 4: // confirma email
            return true
        default:
            return false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Cuando se reconoce un tap se llama esta función
    func escondeTeclado() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
