//
//  FAQModel.swift
//  BA
//
//  Created by Felizia Bernutz on 25.01.16.
//  Copyright © 2016 Felizia Bernutz. All rights reserved.
//

import UIKit

class FAQModel {
    
    func provideFAQs() -> [ FAQ ] {
        return [ homeKit(),
            controlWhenAway(),
            accessoryTypes(),
            availableAccessories(),
            iBeacons(),
            iBeaconConnection(),
            creatingActionSet(),
            communicationWithPhone(),
            futureFeatures() ]
    }
    
    class func homeKit() -> FAQ {
        let qString = "Was ist HomeKit?"
        let aString = "HomeKit ist der von Apple entwickelte Home Automation-Standard. Damit können Nutzer über ein iPhone, iPad oder iPod touch mit Geräten kommunizieren, die das Merkmal \"Works with Apple HomeKit\" von Apple tragen. Das können unter anderem Lampen, Schlösser oder Thermostate sein."
        return FAQ(question: qString, answer: aString)
    }
    
    class func controlWhenAway() -> FAQ {
        let qString = "Kann man die Geräte auch von unterwegs steuern?"
        let aString = "Das ist möglich, wenn man einen Apple TV (3. Generation oder neuer) besitzt. Diese Funktion wird im Moment noch nicht unterstützt."
        return FAQ(question: qString, answer: aString)
    }
    
    class func accessoryTypes() -> FAQ {
        let qString = "Welche Gerätetypen kann ich hinzufügen?"
        let aString = "Man kann Eve Energy, Eve Weather, Eve Door&Window und Lampen hinzufügen. Dieses Angebot wird jedoch stets weiterentwickelt werden."
        return FAQ(question: qString, answer: aString)
    }
    
    class func availableAccessories() -> FAQ {
        let qString = "Welche Geräte sind momentan (Stand: 02/16) im deutschen Markt verfügbar?"
        let aString = "Philips Hue, Eve Elgato, Netatmo, Parce One, monkey - Haustüröffner, Nanoleaf Smarter Kit und CommandKit Wireless Smart Light Bulb Adapter."
        return FAQ(question: qString, answer: aString)
    }
    
    class func communicationWithPhone() -> FAQ {
        let qString = "Kommunizieren die Geräte über WLAN oder Bluetooth mit meinem iPhone?"
        let aString = "Für die Steuerung der Geräte von Eve Elgato ist eine Kommunikation mit Bluetooth erforderlich. Jedoch unterstützt HomeKit generell auch die WLAN Kommunikation."
        return FAQ(question: qString, answer: aString)
    }
    
    class func iBeacons() -> FAQ {
        let qString = "Was sind iBeacons und wie funktionieren sie? "
        let aString = "iBeacons sind kleine Bluetooth-Sender. Diese senden Bluetooth-Low-Energy-Signale aus, welche von iPhones mit aktiviertem Bluetooth empfangen werden können. Dadurch wird erkannt, ob sich iPhones in der Nähe eines iBeacons befinden oder nicht. Diese Funktionalität kann gut in der Home Automation angewendet werden, indem beispielsweise alle Geräte ausgeschalten werden, wenn das Haus und somit die Reichweite des iBeacons verlassen wird."
        return FAQ(question: qString, answer: aString)
    }
    
    class func iBeaconConnection() -> FAQ {
        let qString = "Wie kann ich ein iBeacon mit einem Raum verknüpfen?"
        let aString = "Das näheste iBeacon wird dem angezeigtem Raum hinzugefügt, wenn man auf den Button in der Kategorie \"Verknüpftes iBeacon\" drückt. Jedes Mal, wenn man nun in die Nähe dieses iBeacons kommt, kann man schnell zu dem verknüpften Raum mit den jeweiligen Geräten navigieren."
        return FAQ(question: qString, answer: aString)
    }
    
    class func creatingActionSet() -> FAQ {
        let qString = "Was sind Action Sets und wofür kann man sie benutzen?"
        let aString = "Mit Action Sets kannst du durch einen Auslöser eine Kette von Aktionen hervorrufen. Auslöser können unter anderem eine Statusänderung eines Gerätes sein, die Uhrzeit (wie die Zeit des Sonnenaufgangs) oder das Betreten oder Verlassen eines bestimmten Bereichs - auch Geofence - genannt, das entweder über GPS-Koordinaten oder durch iBeacons erkannt werden kann. Denkbar ist dann zum Beispiel nach Sonnenuntergang alle Lichter in den am meisten genutzten Zimmern einzuschalten oder beim Verlassen des Hauses alle nicht dauerhaft genutzte Geräte auszuschalten."
        return FAQ(question: qString, answer: aString)
    }
    
    class func futureFeatures() -> FAQ {
        let qString = "Was für Funktionalitäten werden noch folgen?"
        let aString = "- Tutorial zur Unterstützung zum Einrichten der App\n- Navigation zum schnelleren Filtern der Geräte\n- Unterstützung von mehr Characteristics\n- Unterstützung von mehr Gerätetypen\n- Erstellen von Action Sets ermöglichen\n- Automatische Aktualisierung der Geräte nach 10 Minuten oder beim Verlassen oder Betreten eines bestimmten Bereiches\n- Anzeige, wenn Geräte außer Reichweite sind\n- Löschen und Hinzufügen von Räumen und Häusern\n- Löschen von Geräten\n- Designverbesserungen\n- Mehr nutzerfreundliche Details, wie das Sortieren der Geräte und das Festlegen, welche Informationen für das Gerät angezeigt werden soll"
        return FAQ(question: qString, answer: aString)
    }
}

struct FAQ {
    let question : String
    let answer : String
    
    init(question : String, answer : String) {
        self.question = question
        self.answer = answer
    }
}
