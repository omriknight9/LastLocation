

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!;
    
    let locationManager = CLLocationManager();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        locationManager.delegate = self;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
        
        updateSavedPin();
    }
    
    func updateSavedPin() {
        if let oldCoords = DataStore().getLastLocation() {
            
            let annoRemove = mapView.annotations.filter{$0 !== mapView.userLocation}
            mapView.removeAnnotations(annoRemove);
            
            let annotation = MKPointAnnotation();
            annotation.coordinate.latitude = Double(oldCoords.latitude)!;
            annotation.coordinate.longitude = Double(oldCoords.logitude)!;
            
            annotation.title = "I was here";
            annotation.subtitle = "Remember?";
            mapView.addAnnotation(annotation);
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            print("OMRI: Location not enabled");
            return;
        }
        print("OMRI: Location allowed");
        mapView.showsUserLocation = true;
    }
    @IBAction func saveBtnClicked(_ sender: AnyObject) {
        let coord = locationManager.location?.coordinate;
        
        if let lat = coord?.latitude, let long = coord?.longitude {
            DataStore().storeDataPoint(latitude: String(lat), longitude: String(long));
            let alert = UIAlertController(title: "Your Location:", message: "Latitude: \(lat) \n Longitude: \(long)", preferredStyle: UIAlertControllerStyle.alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil));
            self.present(alert, animated: true, completion: nil);
            
            updateSavedPin();

        }
        
    }

}

