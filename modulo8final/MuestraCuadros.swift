//
//  MuestraCuadros.swift
//  modulo8final
//
//  Created by Raymundo Peralta on 3/29/17.
//  Copyright © 2017 Raymundo Peralta. All rights reserved.
//

import UIKit


class MuestraCuadros: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var frutas = [[:]]
    
    lazy var directorioDocuments:NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count - 1] // devuelve el ultimo, [0] regresa el primero
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("llegamos al muestra cuadros")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.URLByAppendingPathComponent("frutas.json").path!
        let fileManager = NSFileManager.defaultManager()
        print(filePath)
        if fileManager.fileExistsAtPath(filePath) {
            print("Existe el archivo")
        } else {
            print("No esxiste el archivo")
        }
        
        do {
            let jsonData = try NSData(contentsOfFile: filePath, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            print(jsonData)
            do {
                let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                frutas = jsonResult["frutas"] as! [NSDictionary]
                
            } catch {}
        } catch {}
        if frutas.count > 0 {
            for fruta: NSDictionary in frutas {
                for (name,value) in fruta {
                    print("\(name) , \(value)")
                }
            }
        }
        print(frutas[0])
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("entramos al numero de celdas")
        return self.frutas.count
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier = "cell"
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.myLabel.text = (self.frutas[indexPath.item]["titulo"] as! String)
        cell.myImage.image = UIImage(named: cell.myLabel.text!)
        cell.backgroundColor = UIColor.cyanColor() // make cell more visible in our example project
        
        return cell
    }
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        if indexPath.item == 8 {
            // Brincar a la primer pantalla
            self.performSegueWithIdentifier("IrPrimeraPantalla2", sender: self)
            print("Nos vamos a la primer pantalla")
        }
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
