//
//  ViewController.swift
//  modulo8final
//
//  Created by Raymundo Peralta on 3/27/17.
//  Copyright © 2017 Raymundo Peralta. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var UITextFieldTelefono: UITextField!
    
    @IBOutlet weak var outletBtnSiguiente: UIButton!
    
    @IBAction func btnSiguiente(sender: UIButton) {
        let numero:String = UITextFieldTelefono.text!
        if numero.characters.count == 10 {
            print("tenemos 10 caracteres axactamente y son solo numeros por construcción.")
            
            // Lo que tenemos que hacer es buscar el numero de telefono en la base de datos
            // si está nos vamos al menu de cuadricula, si no está nos vamos a la captura de datos
            
            let managedContext = CoreDataStack.sharedInstance.managedObjectContext
            let select = NSFetchRequest(entityName: "Usuarios")
            select.predicate = NSPredicate(format: "telefono = %@", numero)
            do{
                let usuarios = try managedContext.executeFetchRequest(select) as NSArray as! [Usuarios]
                
                print(usuarios.count)
                
                if usuarios.count > 0 {
                    print("El número de telefóno ya está registrado")
                    // saltamos al menu de cuadricula
                    self.performSegueWithIdentifier("MuestaCuadrosSegue", sender: self)
                } else {
                    print("El número de telefóno no esta registrado")
                    // saltamos a la captura de datos
                    self.performSegueWithIdentifier("CapturaDatosSegue", sender: self)
                }
                print("Salimos del boton")
                
            } catch let error{
                print(error)
            }
        } else {
            print("Nunca debemos llegar aquí porque el uitextfield habilitra el boton cuando hay 10 caracteres")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "CapturaDatosSegue") {
            //Hay que checar el identificador del segue
            let CapturaDatosVC = segue.destinationViewController as! CapturaDeInformacion
            CapturaDatosVC.telefono = UITextFieldTelefono.text
        }
    }
    
    var ding:AVAudioPlayer = AVAudioPlayer()
    
    //lazy var directorioDocuments:NSURL = {
    //    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    //    return urls[urls.count - 1] // devuelve el ultimo, [0] regresa el primero
    //}()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        outletBtnSiguiente.enabled = false
        UITextFieldTelefono.delegate = self
        
        preparaDing()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.escondeTeclado))
        view.addGestureRecognizer(tap)
        
        //let destino = directorioDocuments.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        //print(">>>")
        //print(destino)
    }

    // En este view controler solo tengo un uitextfield no es necesario diferenciarlo
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("TAG \(textField.tag)")
        if (range.length == 1 && string.isEmpty){
            print("tecleamos back space")
            print(textField.text!)
            print(string)
            print("------")
            print(textField.text?.characters.count)
            let result = String.init(textField.text!.characters.dropLast())
            print(result.characters.count)
            if result.characters.count == 10 {
                outletBtnSiguiente.enabled = true
            } else {
                outletBtnSiguiente.enabled = false
             }
            textField.text = result
            print(textField.text!)
            print(">>>>>>>>")
            return false
        }
        let nuevoTamaño = textField.text!.characters.count + string.characters.count - range.length
        //debug para ver el tamaño del nuevo texto
        print("nuevo tamaño " + String(nuevoTamaño))
        print("text visible " + textField.text!)
        let data = string.dataUsingEncoding(NSUTF8StringEncoding)
        print("string " + string + "- " + "\(data)")
        if let entero = Int(string) {
            // Tout vas bien
            print("tenemos un numero \(entero)")
            if nuevoTamaño == 10 {
                outletBtnSiguiente.enabled = true
            }
            return nuevoTamaño <= 10
        } else {
            print("tenemos un no numero")
            // Cuando se teclea un caracter que no es un numero sonamos un ding para avisarle al usuario
            // que no puede teclear ese caracter
            ding.play()
            return false // no se permite agregar el caracter
        }
    }
    
    func preparaDing() {
        let path = NSBundle.mainBundle().pathForResource("ding", ofType: "mp3")
        do {
            ding = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path!), fileTypeHint: nil)
        } catch let error as NSError {
            print("tenemos un problema con el anuncio sonoro \(error), \(error.userInfo)")
        }
        ding.prepareToPlay()
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

}

