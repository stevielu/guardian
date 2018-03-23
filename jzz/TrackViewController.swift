//
//  TrackViewController.swift
//  jzz
//
//  Created by wei lu on 18/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import HealthKit
import CoreData
import SnapKit
import CoreBluetooth
import QuartzCore

class TrackViewController: UIViewController {
    var mapView: MKMapView!
    var distanceLabel: UILabel!
    var timeLabel: UILabel!
    var paceLabel: UILabel!
    var trackButton:UIButton!
    var llcManager: CLLocationManager!
    var seconds = 0.0
    var distance = 0.0
    var round = 0
    var oldRound = 0
    var delaySecond = 0
    
    let server = ServiceDataProcess()
    lazy var timer = Timer()
    lazy var locations = [CLLocation]()
    lazy var currentLocation = CLLocation()
    var updateGeo = true
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    var buttonBool: Bool = false
    
    var cancelAlert: Bool = false
    //Blue tooth
    var isScaning = false
    var bluetoothPowerOff = false
    var timeoutMonitor:Timer!
    let bluetoothManager = BluetoothManager.getInstance()
    var connectingView : ConnectingView?
    var nearbyPeripherals : [CBPeripheral] = []
    var nearbyPeripheralInfos : [CBPeripheral:Dictionary<String, AnyObject>] = [CBPeripheral:Dictionary<String, AnyObject>]()
    var deviceListTableView:PeripheralsListTableViewController!
    var characteristic : CBCharacteristic?
    var properties : [String]?
    fileprivate var services : [CBService]?
    fileprivate var characteristicsDic = [CBUUID : [CBCharacteristic]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.createLocationManager()
        self.prepareUI()
        self.mapView.mapType = MKMapType.standard
        self.mapView.delegate = self
        self.mapView.isZoomEnabled = true
        self.mapView.isScrollEnabled = true
        self.mapView.showsUserLocation = true
        
        //Bluetooth Set
        bluetoothManager.delegate = self
        deviceListTableView.bluetoothManager = self.bluetoothManager
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        llcManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc fileprivate func prepareUI(){
        self.distanceLabel = UILabel()
        self.trackButton = UIButton()
        self.timeLabel = UILabel()
        self.paceLabel = UILabel()
        self.mapView = MKMapView()
        self.deviceListTableView = PeripheralsListTableViewController()
        view.addSubview(mapView)
        view.addSubview(trackButton!)
        view.addSubview(distanceLabel)
        view.addSubview(paceLabel)
        
        
        distanceLabel.font = globalStyle.titleFont
        distanceLabel.textColor = globalStyle.titleColor
        paceLabel.font = globalStyle.titleFont
        paceLabel.textColor = globalStyle.titleColor
        
        trackButton.imageView?.contentMode = .scaleAspectFit
        trackButton.setImage(UIImage(named:"disconnected"), for: .normal)
        
        
        trackButton?.addTarget(self, action: #selector(didTap), for: .touchDown)
        
        self.mapView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        self.trackButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.snp.bottom).offset(-75)
            make.width.height.equalTo(75)
        }
        self.distanceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(25)
            make.left.equalTo(self.view.snp.left).offset(12.5)
            make.right.equalTo(self.view.snp.right).offset(-12.5)
            make.height.equalTo(25)
        }
        self.paceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.distanceLabel.snp.bottom).offset(10)
            make.left.equalTo(self.view.snp.left).offset(12.5)
            make.right.equalTo(self.view.snp.right).offset(-12.5)
            make.height.equalTo(25)
        }
        
    }
    
    //MARK : - Event
    @objc fileprivate func didTap(){
        self.buttonBool = !self.buttonBool
        if(buttonBool == true){
            //scan bluetooth
            if(self.bluetoothPowerOff == true){
                UnavailableView.showUnavailableView()
                return
            }else{
                UnavailableView.hideUnavailableView()
                bluetoothManager.startScanPeripheral()
                self.scaning()
            }
            
            //trackButton?.setImage(UIImage(named:"connected_100%"), for: .normal)
        }else{
            self.stopMonitor()
        }
    }
    
    @objc fileprivate func didTapStart(){
        distance = 0.0
        locations.removeAll(keepingCapacity: false)
        self.timer = Timer.scheduledTimer(timeInterval: 1,
                                                       target: self,
                                                       selector: #selector(eachSecond),
                                                       userInfo: nil,
                                                       repeats: true)
        startLocationUpdates()
    }
    
    
    //MARK : - Delegate
    //
    //
        
        
    //MARK: - Help Function
    func eachSecond(timer: Timer) {
        self.seconds += 1
        let secondsQuantity = HKQuantity(unit: HKUnit.second(), doubleValue: seconds)
        timeLabel.text = "Time: " + secondsQuantity.description
        let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)
        
        let str1Array = distanceQuantity.description.components(separatedBy: ".")
        self.distanceLabel.text = "Distance: " + str1Array[0] + "m"
        
        let paceUnit = HKUnit.second().unitDivided(by: HKUnit.meter())
        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: seconds / distance)
        paceLabel.text = "Pace: " + paceQuantity.description
    }
    
    func startLocationUpdates() {
        // Here, the location manager will be lazily instantiated
        llcManager.startMonitoringSignificantLocationChanges()
        llcManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        // Here, the location manager will be lazily instantiated
        if(llcManager != nil){
            llcManager.stopUpdatingLocation()
        }
        timer.invalidate()
    }
    
    func stopMonitor(){
        //stop track
        trackButton?.setImage(UIImage(named:"disconnected"), for: .normal)
        self.stopLocationUpdates()
        oldRound = 0
        round = 0
        self.updateGeo = true
        //disconnect ble preipheral
        
        bluetoothManager.stopScanPeripheral()
        if bluetoothManager.connectedPeripheral != nil {
            bluetoothManager.setNotification(enable: true, forCharacteristic: self.characteristic!)
            bluetoothManager.disconnectPeripheral()
        }
    }
    //MARK： - Function
    //
    //
    
    func createLocationManager() {
        llcManager = CLLocationManager()
        llcManager.delegate = self
        llcManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        llcManager.distanceFilter = 10.0
        llcManager.activityType = .fitness
        llcManager.allowsBackgroundLocationUpdates = true
    }
    
    func saveRun() {
        
    }
    
    func scaning(){
        self.pleaseWait()
        if !isScaning {
            isScaning = true
            timeoutMonitor = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.scanTimeout(_:)), userInfo: nil, repeats: false)
        }
    }
    
    func scanTimeout(_ timer : Timer){
        self.clearAllNotice()
        if isScaning {
            isScaning = false
            
            //connectPeripheral(timer.userInfo as! CBPeripheral)
            timeoutMonitor.invalidate()
            timeoutMonitor = nil
            self.buttonBool = false
            
            if(nearbyPeripherals.count == 0){
                self.stopLocationUpdates()
                //disconnect ble preipheral
                bluetoothManager.stopScanPeripheral()
                if bluetoothManager.connectedPeripheral != nil {
                    bluetoothManager.disconnectPeripheral()
                }
                self.notice("No Device", type: .info, autoClear: true, autoClearTime: 3)
            }else{
                
                view.addSubview(deviceListTableView.tableView)
                self.deviceListTableView.tableView.snp.makeConstraints { (make) in
                    make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(45)
                    make.left.equalTo(self.view.snp.left).offset(35)
                    make.right.equalTo(self.view.snp.right).offset(-35)
                    make.bottom.equalTo(self.view.snp.bottom).offset(-45)
                }
                self.addChildViewController(deviceListTableView)
                self.deviceListTableView.willMove(toParentViewController: self)
            }
            
        }
    }
    
    fileprivate func dectIfForeground() -> Bool {
        let state = UIApplication.shared.applicationState
        if state == .background {
        // background
            return false
        }
        // foreground
        return true
    }
    
    @objc fileprivate func makeAlert(){
        if(cancelAlert == true){
            return
        }
        let user = UserDefaults.standard.object(forKey: "ActiveUser")
        if user == nil{
            return
        }
        
        let data = httpData()
        data.data = [
            "UserName":user!,
            "Lat": self.currentLocation.coordinate.latitude,
            "Lon": self.currentLocation.coordinate.longitude
        ]
        data.Httpmethod = .post
        server.httpAct(requestUrl: MAKE_ALERT, Senddata: data, completion: {ret in
            if(ret as? Bool == true){
                self.generateLocalNotification(messageContent: "Help Request has been sent",cancelString: "Okay")
            }else{
            }
        })
    }
    
    @objc fileprivate func makeAlertWithDelay(){
        if let topController = UIApplication.topViewController() {
            topController.dismiss(animated: true, completion: nil)
        }
        makeAlert()
    }
    
    fileprivate func generateLocalNotification(messageContent:String,cancelString:String,cancelHandle:((UIAlertAction) -> Swift.Void)? = nil){
        if let topController = UIApplication.topViewController() {
            AlertUtil.showCancelAlert("Alert", message: messageContent, cancelTitle: cancelString, viewController: topController,handler: cancelHandle)
            
        }
        if(self.dectIfForeground() == false){//app run in background
            AlertUtil.createLocalNotification(content: messageContent)
        }
    }

}
// MARK: - Bluetooth Delegate
extension TrackViewController:BluetoothDelegate{
    // MARK: BluetoothDelegate
    func didDiscoverPeripheral(_ peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        if !nearbyPeripherals.contains(peripheral) {
            nearbyPeripherals.append(peripheral)
            nearbyPeripheralInfos[peripheral] = ["RSSI": RSSI, "advertisementData": advertisementData as AnyObject]
        } else {
            nearbyPeripheralInfos[peripheral]!["RSSI"] = RSSI
            nearbyPeripheralInfos[peripheral]!["advertisementData"] = advertisementData as AnyObject?
        }
        self.deviceListTableView.nearbyPeripheralInfos = self.nearbyPeripheralInfos
        self.deviceListTableView.nearbyPeripherals = self.nearbyPeripherals
        self.deviceListTableView.tableView.reloadData()
    }
    
    func didDiscoverDescriptors(_ characteristic: CBCharacteristic) {
        print("CharacteristicController --> didDiscoverDescriptors")
        self.characteristic = characteristic
    }
    
    /**
     The bluetooth state monitor
     
     - parameter state: The bluetooth state
     */
    func didUpdateState(_ state: CBCentralManagerState) {
        print("MainController --> didUpdateState:\(state)")
        switch state {
        case .resetting:
            print("MainController --> State : Resetting")
        case .poweredOn:
            self.bluetoothPowerOff = false
            UnavailableView.hideUnavailableView()
        case .poweredOff:
            self.bluetoothPowerOff = true
            print(" MainController -->State : Powered Off")
            fallthrough
        case .unauthorized:
            print("MainController --> State : Unauthorized")
            fallthrough
        case .unknown:
            print("MainController --> State : Unknown")
            fallthrough
        case .unsupported:
            self.bluetoothPowerOff = true
            print("MainController --> State : Unsupported")
            bluetoothManager.stopScanPeripheral()
            bluetoothManager.disconnectPeripheral()
            ConnectingView.hideConnectingView()
            
            
        }
    }
    
    /**
     The callback function when central manager connected the peripheral successfully.
     
     - parameter connectedPeripheral: The peripheral which connected successfully.
     */
    func didConnectedPeripheral(_ connectedPeripheral: CBPeripheral) {
        print("MainController --> didConnectedPeripheral")
        //self.deviceListTableView.connectingView?.tipLbl.text = "Connected..."
        ConnectingView.hideConnectingView()
        
        
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: {(UIAlertAction) in
            if self.bluetoothManager.connected {
                //get characterisc
                print(self.characteristicsDic[self.services![1].uuid]![0])
                self.characteristic =  self.characteristicsDic[self.services![1].uuid]![0]
                assert(self.characteristic != nil, "The Characteristic CAN'T be nil")
                self.bluetoothManager.setNotification(enable: true, forCharacteristic: self.characteristic!)
                characteristicGlobal = self.characteristic
                
                
                //start track
                self.didTapStart()
                self.trackButton?.setImage(UIImage(named:"connected_100%"), for: .normal)
                
                
                //set up variable
                self.buttonBool = true
                
                //set up device
                if let config = UserDefaults.standard.object(forKey: "DeviceConfig") as? [String:Any]{
                    if let value = config["PressGesture"] as? [String:Bool]{
                        let value = value["Press1"] == true ? WR_CONFIG_PRESS_ONE:value["Press2"] == true ? WR_CONFIG_PRESS_TWO:value["Press3"] == true ? WR_CONFIG_PRESS_THREE:WR_CONFIG_PRESS_ONE
                        self.setDeviceGesture(value: value)
                    }
                    
                }
                
                self.bluetoothManager.stopScanPeripheral()
            }
        })
        
        let controller = UIAlertController(title: "Connected", message: "Alva has connected your phone", preferredStyle: .alert)
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    func didDisconnectPeripheral(_ peripheral: CBPeripheral) {
        self.buttonBool = false
        //stop tracking
        self.stopMonitor()
        //clear geo info
        self.updateGeoInfo(lat: "0", lon: "0")
        //clear map route traking
        if(self.mapView != nil){
            self.mapView.overlays.forEach {
                if !($0 is MKUserLocation) {
                    self.mapView.remove($0)
                }
            }
        }
    }
    
    /**
     The peripheral services monitor
     
     - parameter services: The service instances which discovered by CoreBluetooth
     */
    func didDiscoverServices(_ peripheral: CBPeripheral) {
        services = bluetoothManager.connectedPeripheral?.services
        bluetoothManager.discoverCharacteristics()
        
        
//        print("MainController --> didDiscoverService:\(peripheral.services)")
//        ConnectingView.hideConnectingView()
//        let peripheralController = PeripheralController()
//        let peripheralInfo = nearbyPeripheralInfos[peripheral]
//        peripheralController.lastAdvertisementData = peripheralInfo!["advertisementData"] as? Dictionary<String, AnyObject>
//        self.navigationController?.pushViewController(peripheralController, animated: true)
    }
    
    /**
     The method invoked when interrogated fail.
     
     - parameter peripheral: The peripheral which interrogation failed.
     */
    func didFailedToInterrogate(_ peripheral: CBPeripheral) {
        ConnectingView.hideConnectingView()
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: {(ALertAction) in
            self.buttonBool = false
            self.stopMonitor()
        })
        let controller = UIAlertController(title: "Connection Alert", message: "The perapheral disconnected while being interrogated.", preferredStyle: .alert)
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    func didDiscoverCharacteritics(_ service: CBService) {
        print("Service.characteristics:\(service.characteristics)")
        characteristicsDic[service.uuid] = service.characteristics
    }
    
    func didReadValueForCharacteristic(_ characteristic: CBCharacteristic) {
        print("CharacteristicController --> didReadValueForCharacteristic")
        if characteristic.value != nil && characteristic.value!.count != 0 {
            let valueArray = characteristic.description.components(separatedBy:",")
            let predicate = NSPredicate(format: "SELF contains %@", "value")
            let data = valueArray.filter({ predicate.evaluate(with: $0)})[0]
            let index = data.index(data.startIndex, offsetBy: 9)
            let value = data.substring(from: index)
            parseReadedValue(value: value)
        }
        
    }
    
    func parseReadedValue(value:String){
        self.cancelAlert = false
        let actived = UserDefaults.standard
        
        switch value {
            //Post Help Alert
        case RD_ACTIVE_ALARM:
            self.makeAlert()
            actived.set("True", forKey: "Alarm")
            break
        case RD_PASSIVE_ALARM:
            actived.set("True", forKey: "Alarm")
            self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
            })
            var timer = Timer.scheduledTimer(timeInterval: TIMER_HELP_REQUEST, target: self, selector: #selector(self.makeAlertWithDelay), userInfo: nil, repeats: false)
            generateLocalNotification(messageContent: "Help request will be sent after 120s",cancelString: "Cancel Request",cancelHandle: { (UIAlertAction) in
                self.cancelAlert = true
            })
            break
        default:
            break
        }
    }
    
    fileprivate func setDeviceGesture(value:String){
        if (self.bluetoothManager.connected == true && characteristicGlobal != nil){
            var hexString = value.substring(from: value.characters.index(value.startIndex, offsetBy: 2))
            if hexString.characters.count % 2 != 0 {
                hexString = "0" + hexString
            }
            let data = hexString.dataFromHexadecimalString()
            self.bluetoothManager.writeValue(data: data!, forCharacteristic: characteristicGlobal!, type: .withoutResponse)
            
            
        }
    }
    
    
}




// MARK: - MKMapViewDelegate
extension TrackViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = globalStyle.buttonFillColorRed
        renderer.lineWidth = 3
        return renderer
    }
}

extension TrackViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations{
            let howRecent = location.timestamp.timeIntervalSinceNow
            self.currentLocation = location
            if abs(howRecent) < 10 && location.horizontalAccuracy < 20 {
                //update distance
                if self.locations.count > 0 {
                    distance += location.distance(from: self.locations.last!)
                    
                    var coords = [CLLocationCoordinate2D]()
                    coords.append(self.locations.last!.coordinate)
                    coords.append(location.coordinate)
                    
                    let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
                    mapView.setRegion(region, animated: true)
                    
                    mapView.add(MKPolyline(coordinates: &coords, count: coords.count))
                }
                
                //save location
                self.locations.append(location)
                
                //update location
                round = Int(distance / 2500.0)
                if(round - oldRound != 0){
                    oldRound = round
                    updateGeo = true
                }
                
                if updateGeo{
                    updateGeo = !updateGeo
                    self.updateGeoInfo(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                }
                
            }
        }
    }

    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

}

extension TrackViewController{
    //update geo info
    func updateGeoInfo(lat:Any,lon:Any){
        let data = httpData()
        if let user = UserDefaults.standard.object(forKey: "ActiveUser"){
            data.data = [
                "UserName":user,
                "Lat":lat,
                "Lon":lon,
                "TrackingStatus":"normal"
            ]
            data.Httpmethod = .post
            self.server.httpAct(requestUrl: UPDATE_GEO, Senddata: data, completion: {ret in
                print(ret)
                self.noticeInfo("Updating...", autoClear: true, autoClearTime: 3)
            })
        }
    }
}
