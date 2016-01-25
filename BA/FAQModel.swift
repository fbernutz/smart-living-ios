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
        let aString = "HomeKit ist der von Apple entwickelte Heimautomationsstandard. Damit kann man über ein iPhone mit Geräten, die HomeKit unterstützen kommunizieren."
        return FAQ(question: qString, answer: aString)
    }
    
    private func controlWhenAway() -> FAQ {
        let qString = "Kann man die Geräte auch von unterwegs steuern?"
        let aString = "Das ist theoretisch möglich, wenn man einen Apple TV besitzt. Diese Funktion wird im Moment aber noch nicht unterstützt."
        return FAQ(question: qString, answer: aString)
    }
    
    private func iBeacons() -> FAQ {
        let qString = "Was sind iBeacons und wie funktionieren sie? "
        let aString = "iBeacons sind kleine Bluetooth-Sender. Diese senden Signale aus, welche von einem sich in der Nähe aufhaltendem iPhone mit eingeschaltetem Bluetooth erkannt werden. Somit lässt sich feststellen, ob der Nutzer sich in der Nähe des Beacons aufhält.\nAnwendungsfall:...?"
        return FAQ(question: qString, answer: aString)
    }
    
    private func iBeaconConnection() -> FAQ {
        let qString = "Wie kann ich ein Beacon mit einem Raum verknüpfen?"
        let aString = "Man kann ein Beacon mit einem Raum verknüpfen, indem man auf den Beacon-Button drückt und möglichst nur das eine Beacon in der Nähe des iPhones liegt. Das näheste Beacon wird dann diesem Raum hinzugefügt."
        return FAQ(question: qString, answer: aString)
    }
    
    private func accessoryTypes() -> FAQ {
        let qString = "Welche Gerätetypen kann ich hinzufügen?"
        let aString = "Man kann Eve Energy, Eve Weather, Eve Door&Window und Lampen hinzufügen. Dieses Angebot wird jedoch stets weiterentwickelt und es werden bald mehr Geräte hinzufügbar sein."
        return FAQ(question: qString, answer: aString)
    }
    
    private func availableAccessories() -> FAQ {
        let qString = "Welche Geräte sind momentan im deutschen Markt verfügbar?"
        let aString = "Philips Hue, Eve Elgato, Netatmo"
        return FAQ(question: qString, answer: aString)
    }
    
    private func communicationWithPhone() -> FAQ {
        let qString = "Kommunizieren die Geräte über WLAN oder Bluetooth mit meinem iPhone?"
        let aString = "Für die Steuerung der Geräte von Eve Elgato ist eine Kommunikation mit Bluetooth erforderlich. Jedoch unterstützt HomeKit generell auch die WLAN Kommunikation. "
        return FAQ(question: qString, answer: aString)
    }
    
    private func futureFeatures() -> FAQ {
        let qString = "Was für Funktionalitäten sollen noch folgen? "
        let aString = "- Tutorial als Unterstützung zum Einrichten der App\n- Navigation zum schnelleren Filtern\n- Unterstützung von mehr Characteristics\n- Unterstützung von mehr Gerätetypen\n- Erstellen von Action Sets ermöglichen\n- Automatische Aktualisierung der Accessories nach 10 Min oder beim Verlassen/Betreten eines Bereiches\n- Anzeige, wenn Accessories außer Reichweite sind\n- Löschen und Hinzufügen von Räumen und Homes\n- Löschen von Accessories\n- Designverbesserungen\n- Mehr nutzerfreundliche Details, wie das Sortieren der Accessories und dem Aussuchen, welche Informationen für das Accessory angezeigt werden soll"
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