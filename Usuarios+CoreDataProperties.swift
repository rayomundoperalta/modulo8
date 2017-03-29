//
//  Usuarios+CoreDataProperties.swift
//  modulo8final
//
//  Created by Raymundo Peralta on 3/28/17.
//  Copyright © 2017 Raymundo Peralta. All rights reserved.
//

import Foundation
import CoreData

extension Usuarios {
    
    @NSManaged var telefono: String?
    @NSManaged var contrasena: String?
    @NSManaged var correo: String?
}
