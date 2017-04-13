//
//  AppDelegate.swift
//  Reminder
//
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

enum NotificationIdentifiers: String {
    case mainCategory = "Lembrete"
    case doneAction = "Realizada"
    case showAction = "Mostrar"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: "92b17bea-4fa9-4b22-9148-f5e55e5ec136")
        
        // App carregado, vamos configurar a central de notificações
        center.delegate = self
        
        // Verifica se o usuário aceitou receber notificações
        center.getNotificationSettings { (settings: UNNotificationSettings) in
            if settings.authorizationStatus == .notDetermined {
                let options: UNAuthorizationOptions = [.alert, .sound, .badge]
                // Vamos requisitar ao usuário a autorização
                self.center.requestAuthorization(options: options, completionHandler: { (success: Bool, error: Error?) in
                    if error == nil {
                        if success {
                            print("Usuário autorizou as notificações")
                        } else {
                            print("Usuário negou as notificações")
                            
                            // TODO Perguntar de tempos em tempos se deseja aceitar, para recuperar o user
                        }
                    }
                })
            }
        }
        
        // Quais ações que o usuário vai poder fazer no push de uma categoria
        let doneAction = UNNotificationAction(identifier: NotificationIdentifiers.doneAction.rawValue, title: "Já fiz!", options: [.destructive, .foreground])
        
        let showAction = UNNotificationAction(identifier: NotificationIdentifiers.showAction.rawValue, title: "Mostrar!", options: [.foreground])
        
        let mainCategory = UNNotificationCategory(identifier: NotificationIdentifiers.mainCategory.rawValue, actions:
            [doneAction, showAction], intentIdentifiers: [], options: .customDismissAction)
        // customDismissAction: a gente sabe se o usuário viu a notificação mas cagou pra ela
        
        center.setNotificationCategories([mainCategory]) // define a lista de categorias
        
        //let remove
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Reminder")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Notificação Visualizada")
        
        // Conteúdo da notificação
        print(response.notification.request.content)
        
        // com esse cara dá pra saber em qual acao ele clicou
        switch response.actionIdentifier {
            
            case NotificationIdentifiers.doneAction.rawValue:
                print("Disse que já fez a tarefa")
            
            case NotificationIdentifiers.showAction.rawValue:
                print("Quer mostrar a notificação")
        
            // E se ele fez alguma acao que nao foi a gente que criou? Tipo o dismiss
            case UNNotificationDismissActionIdentifier:
                print("Usuário dismissou/cagou pra mim!!!")
            
            case UNNotificationDefaultActionIdentifier:
                print("Tocou na notificação")
            
            default:
                break
        }
        
        completionHandler() // Tem que chamar aqui no final
    }
    
    // User receives notification when he/she is using the app, so the app is opened on this moment
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert]) // Passar as opções de notificação dessa notificação
    }
}
