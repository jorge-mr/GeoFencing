//
//  ViewController.swift
//  GeoFencing
//
//  Created by Jorge on 13/12/17.
//  Copyright © 2017 kaleido. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation
import UserNotifications

struct Region {
    let identifier : String
    let latitud : Double
    let longitud : Double
    let radio : Double
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var regionsArray : [Region] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateRegions()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in }
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        addRegions()
        locationManager.startUpdatingLocation()
        print(locationManager.monitoredRegions)
    }
    
    func updateRegions(){
        let newRegion = Region(identifier: "Starbucks", latitud: 19.427845, longitud: -99.168495 , radio: 260.0)
        regionsArray.append(newRegion)
        /*newRegion = Region(identifier: "Garabatos cafe", latitud: 19.427314, longitud: -99.165898, radio: 24.0)
        regionsArray.append(newRegion)
        newRegion = Region(identifier: "Oxxo", latitud: 19.425731, longitud: -99.165917, radio: 65.0)
        regionsArray.append(newRegion)
        newRegion = Region(identifier: "Panaderia estocolmo", latitud: 19.426601, longitud: -99.166236, radio: 22.0)
        regionsArray.append(newRegion)*/
        let newRegionn = Region(identifier: "MIDE", latitud: 19.435468, longitud: -99.138420, radio: 200.0)
        regionsArray.append(newRegionn)
        let hotelRegion = Region(identifier: "Hotel", latitud: 19.425142, longitud: -99.164289, radio: 200.0)
        regionsArray.append(hotelRegion)
    }
    
    func addRegions(){
        //guard let longPress = sender as? UILongPressGestureRecognizer else { return }
        //let touchLocation = longPress.location(in: mapView)
        //let coordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
         if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
        for reg in regionsArray {
            let centerCorrdinate = CLLocationCoordinate2D(latitude: reg.latitud, longitude: reg.longitud)
            let region = CLCircularRegion(center: centerCorrdinate, radius: reg.radio, identifier: reg.identifier)
            //mapView.removeOverlays(mapView.overlays)
            region.notifyOnEntry = true
            region.notifyOnExit = true
            locationManager.startMonitoring(for: region)
            let circle = MKCircle(center: centerCorrdinate, radius: reg.radio)
            mapView.add(circle)
            print("SIIIIIIII")

        }
         } else  {
            print("NO SE PUEDEEEEE")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showNotification(title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.badge = 1
        content.sound = .default()
        let request = UNNotificationRequest(identifier: "notif", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let region = region as? CLCircularRegion{
            print("Entraste a una region")
        let title = region.identifier
        let message = "You Entered the Region"
        showAlert(title: title, message: message)
        showNotification(title: title, message: message)
        }else{
            print("no es una region")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let title = region.identifier
        let message = "You Left the Region"
        showAlert(title: title, message: message)
        showNotification(title: title, message: message)
    }
    
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else { return MKOverlayRenderer() }
        let circleRenderer = MKCircleRenderer(circle: circleOverlay)
        circleRenderer.strokeColor = .red
        circleRenderer.fillColor = .red
        circleRenderer.alpha = 0.4
        return circleRenderer
    }
}
