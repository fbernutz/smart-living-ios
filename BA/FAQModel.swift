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
            iBeacons(),
            iBeaconConnection(),
            accessoryTypes(),
            availableAccessories(),
            communicationWithPhone(),
            futureFeatures() ]
    }
    
    private func homeKit() -> FAQ {
        let qString = "Was ist HomeKit?"
        let aString = "HomeKit ist der von Apple entwickelte Heimautomationsstandard. Damit können Nutzer über ein iPhone, iPad oder iPod touch mit Geräten kommunizieren, die das Merkmal \"Works with Apple HomeKit\" von Apple tragen. Das können unter anderem Lampen, Schlösser oder Thermostate sein."
        return FAQ(question: qString, answer: aString)
    }
    
    private func controlWhenAway() -> FAQ {
        let qString = "Kann man die Geräte auch von unterwegs steuern?"
        let aString = "Das ist möglich, wenn man einen Apple TV (3. Generation oder neuer) besitzt. Diese Funktion wird im Moment noch nicht unterstützt."
        return FAQ(question: qString, answer: aString)
    }
    
    private func iBeacons() -> FAQ {
        let qString = "Was sind iBeacons und wie funktionieren sie? "
        let aString = "iBeacons sind kleine Bluetooth-Sender. Diese senden Bluetooth-Low-Energy-Signale aus, welche von iPhones mit aktiviertem Bluetooth empfangen werden können. Dadurch wird erkannt, ob sich iPhones in der Nähe eines iBeacons befinden oder nicht. Diese Funktionalität kann gut in der Heimautomation angewendet werden, indem alle Geräte aussgeschalten werden, wenn das Haus und somit die Reichweite des iBeacons verlassen wird."
        return FAQ(question: qString, answer: aString)
    }
    
    private func iBeaconConnection() -> FAQ {
        let qString = "Wie kann ich ein iBeacon mit einem Raum verknüpfen?"
        let aString = "Das näheste iBeacon wird dem angezeigtem Raum hinzugefügt, wenn man auf den Beacon-Button drückt. Jedes Mal, wenn man nun in die Nähe dieses iBeacons kommt, kann man schnell zu dem verknüpften Raum mit den jeweiligen Geräten navigieren."
        return FAQ(question: qString, answer: aString)
    }
    
    private func accessoryTypes() -> FAQ {
        let qString = "Welche Gerätetypen kann ich hinzufügen?"
        let aString = "Man kann Eve Energy, Eve Weather, Eve Door&Window und Lampen hinzufügen. Dieses Angebot wird jedoch stets weiterentwickelt werden."
        return FAQ(question: qString, answer: aString)
    }
    
    private func availableAccessories() -> FAQ {
        let qString = "Welche Geräte sind momentan im deutschen Markt verfügbar?"
        let aString = "Philips Hue, Eve Elgato, Netatmo, Parce One, monkey - Haustüröffner, Nanoleaf Smarter Kit, CommandKit Wireless Smart Light Bulb Adapter"
        return FAQ(question: qString, answer: aString)
    }
    
    private func communicationWithPhone() -> FAQ {
        let qString = "Kommunizieren die Geräte über WLAN oder Bluetooth mit meinem iPhone?"
        let aString = "Für die Steuerung der Geräte von Eve Elgato ist eine Kommunikation mit Bluetooth erforderlich. Jedoch unterstützt HomeKit generell auch die WLAN Kommunikation."
        return FAQ(question: qString, answer: aString)
    }
    
    private func futureFeatures() -> FAQ {
        let qString = "Was für Funktionalitäten werden noch folgen?"
        let aString = "- Tutorial zur Unterstützung zum Einrichten der App\n- Navigation zum schnelleren Filtern der Geräte\n- Unterstützung von mehr Characteristics\n- Unterstützung von mehr Gerätetypen\n- Erstellen von Action Sets ermöglichen\n- Automatische Aktualisierung der Accessories nach 10 Minuten oder beim Verlassen oder Betreten eines bestimmten Bereiches\n- Anzeige, wenn Accessories außer Reichweite sind\n- Löschen und Hinzufügen von Räumen und Homes\n- Löschen von Accessories\n- Designverbesserungen\n- Mehr nutzerfreundliche Details, wie das Sortieren der Accessories und das Festlegen, welche Informationen für das Accessory angezeigt werden soll"
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