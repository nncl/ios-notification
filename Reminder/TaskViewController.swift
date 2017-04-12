//
//  TaskViewController.swift
//  Reminder
//
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class TaskViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var dpExpiration: UIDatePicker!
    
    // MARK: - Properties
    var task: Task!
    
    /*override var canBecomeFirstResponder: Bool {
        return true
    }*/
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // self.becomeFirstResponder()
        tfName.resignFirstResponder()
    }
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if task != nil {
            tfName.text = task.name!
            dpExpiration.date = task.expiration as! Date
        }
    }

    // MARK: - IBActions
    @IBAction func addUpdateTask(_ sender: UIButton) {
        if task == nil {
            task = Task(context: context)
            sendNotification()
        }
        task.name = tfName.text
        task.expiration = dpExpiration.date as NSDate?
        do {
            try self.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Methods
    func sendNotification() {
        let content = UNMutableNotificationContent() // Conteúdo de uma notificação
        content.title = "Lembrete de Tarefa"
        content.body = tfName.text! // Msg para o usuário
        
        // Arquivo de som tem que ser .CAF
        content.sound = UNNotificationSound.default()
        
        // Categorias - diferentes titulo, botões etc para cada notificação
        content.categoryIdentifier = "Lembrete" // Tipo de categoria, quando essa notificação chegar, ela já sabe o que fazer
        
        // Define quando a notificação vai acontecer, no nosso caso, na data que a gente selecionou
        let dateComponent = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: dpExpiration.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false) // timeInterval = daqui há x segundos vai executar a notificação
        
        let request = UNNotificationRequest(identifier: NotificationIdentifiers.mainCategory.rawValue , content: content, trigger: trigger) // Me dispara isso aí cara
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil) // Pede pra central de notificação atual nos adicionar essa requisição. Não vamos tratar o handle de error
        
        navigationController!.popViewController(animated: true) // Sai desse cara
        
    }
}
