//
//  AddRegistrationTableViewController.swift
//  Hotel Manzana
//
//  Created by Konstantin Ryabtsev on 12.02.2022.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController {
    // MARK: - Outlets
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet weak var numberOfAdultsLabel: UILabel!
    @IBOutlet weak var numberOfAdultsStepper: UIStepper!
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    @IBOutlet weak var numberOfChildrenStepper: UIStepper!
    
    @IBOutlet weak var wifiSwitch: UISwitch!
    @IBOutlet weak var roomTypeLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: - Properties
    var roomType: RoomType?
    var registration = Registration()
    
    let checkInDateLabelIndexPath = IndexPath(row: 0, section: 1)
    let checkInDatePickerIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDateLabelIndexPath = IndexPath(row: 2, section: 1)
    let checkOutDatePickerIndexPath = IndexPath(row: 3, section: 1)
    
    var isCheckInDatePickerShown: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerShown
        }
    }
    var isCheckOutDatePickerShown: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerShown
        }
    }
    
    // MARK: - Methods
    func checkCanSave() {
        guard let roomType = roomType else {
            saveButton.isEnabled = false
            return
        }
        
        let emailPattern = #"^\S+@\S+\.\S+$"#
        
        if firstNameTextField.text!.count == 0 || lastNameTextField.text!.count == 0 ||
            emailTextField.text!.count == 0 || emailTextField.text?.range(of: emailPattern, options: .regularExpression) == nil ||
            roomType.name.count == 0 {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    func saveRegistration() {
        registration.firstName = firstNameTextField.text ?? ""
        registration.lastName = lastNameTextField.text ?? ""
        registration.emailAdress = emailTextField.text ?? ""
        registration.checkInDate = checkInDatePicker.date
        registration.checkOutDate = checkOutDatePicker.date
        registration.numberOfAdults = Int(numberOfAdultsStepper.value)
        registration.numberOfChildren = Int(numberOfChildrenStepper.value)
        registration.roomType = roomType
        registration.wifi = wifiSwitch.isOn
    }
    
    func updateDateViews() {
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(60 * 60 * 24)
        
        checkInDateLabel.text = Registration.getFormatedDate(from: checkInDatePicker.date)
        checkOutDateLabel.text = Registration.getFormatedDate(from: checkOutDatePicker.date)
    }
    
    func updateNumberOfGuests() {
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        
        numberOfAdultsLabel.text = "\(numberOfAdults)"
        numberOfChildrenLabel.text = "\(numberOfChildren)"
    }
    
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
        } else {
            roomTypeLabel.text = "Not Set"
        }
        checkCanSave()
    }
    
    func updateUI() {
        firstNameTextField.text = registration.firstName
        lastNameTextField.text = registration.lastName
        emailTextField.text = registration.emailAdress
        
        checkInDatePicker.minimumDate = registration.checkInDate
        checkInDatePicker.date = registration.checkInDate
        checkOutDatePicker.date = registration.checkOutDate
        
        numberOfAdultsStepper.value = Double(registration.numberOfAdults)
        numberOfChildrenStepper.value = Double(registration.numberOfChildren)
        
        wifiSwitch.isOn = registration.wifi
        roomType = registration.roomType
    }
        
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        updateDateViews()
        updateNumberOfGuests()
        updateRoomType()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SelectRoomType":
            let destination = segue.destination as! SelectRoomTypeTableViewController
            destination.delegate = self
            destination.roomType = roomType
        case "SaveGuest":
            saveRegistration()
        case .none:
            return
        case .some(_):
            return
        }
    }
    
    // MARK: - Actions
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        checkCanSave()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
    }
    
}

// MARK: - UITableViewDataSource
extension AddRegistrationTableViewController /*: UITableViewDataSource */ {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePickerIndexPath:
            return isCheckInDatePickerShown ? UITableView.automaticDimension : 0
        case checkOutDatePickerIndexPath:
            return isCheckOutDatePickerShown ? UITableView.automaticDimension : 0
        default:
            return UITableView.automaticDimension
        }
    }
}

// MARK: - UITableViewDelegate
extension AddRegistrationTableViewController /*: UITableViewDelegate */ {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case checkInDateLabelIndexPath:
            isCheckInDatePickerShown.toggle()
            isCheckOutDatePickerShown = false
        case checkOutDateLabelIndexPath:
            isCheckOutDatePickerShown.toggle()
            isCheckInDatePickerShown = false
        default:
            return
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension AddRegistrationTableViewController: SelectRoomTypeTableViewControllerProtocol {
    func didSelect(roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
    }
}
