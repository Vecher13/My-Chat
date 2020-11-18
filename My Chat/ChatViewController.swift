//
//  ChatViewController.swift
//  My Chat
//
//  Created by Ash on 26.10.2020.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class ChatViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageTextField: UITextView!
    @IBOutlet var chatView: UIView!
    
    
    let db = Firestore.firestore()
    var query: Query!
    var documents = [QueryDocumentSnapshot]()
    var messages = [Message]()
    var limit = 15
    var topPosition = false
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        hideKeyboardOnTapOnScren()
        
        messageTextField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.hidesBackButton = true
        title = "DarkSide"
        tableView.register(UINib(nibName: "MassegeTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
       
       setupKeyboardNotifications()
//        loadMessages()
        getData()
      
    }
    
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }



    @objc func keyboardWillShow(_ notification:NSNotification) {
        let d = notification.userInfo!
        let r = (d[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
  
        self.tableView.contentInset.top = r.size.height
        self.tableView.verticalScrollIndicatorInsets.top = r.size.height


    }

    @objc func keyboardWillHide(_ notification:NSNotification) {
        
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.verticalScrollIndicatorInsets = contentInsets

        
    }
  
    
    func getData(){
        query = db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField, descending: false)
//                        .limit(toLast: limit)
        self.messages = []
        
        query.addSnapshotListener() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        querySnapshot!.documents.forEach({ (document) in
                            let data = document.data() as [String: AnyObject]

                            //Setup your data model
                            
                            if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String{
                                let newMessage = Message(sender: messageSender, body: messageBody)
//                                self.messages.append(newMessage)
                                self.messages += [newMessage]
//                                self.documents += [document]
                             
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    self.tableView.scrollToRow(at: [0, self.messages.count - 1], at: .bottom, animated: false)
                                  
                                }
                            }
                           
                        })
                    }
                }
        
    }
    
    
    func paginate() {
            //This line is the main pagination code.
            //Firestore allows you to fetch document from the last queryDocument
//            query = query.start(afterDocument: documents.last!)
//        print("TOP OF TABLE!")
//            getData()
        }
    
    
    // MARK: - Previous method of fatching data
    
    func loadMessages(){
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField).limit(toLast: 10)
            .addSnapshotListener { (querySnapshot, error) in
            
            self.messages = []
            
            if let e = error {
                print("error \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String{
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                           
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.tableView.scrollToRow(at: [0, self.messages.count - 1], at: .bottom, animated: false)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("Ups.. We have same problems \(e)")
                } else {
                    print("Success!")
                    self.messageTextField.text = ""
                    DispatchQueue.main.async {
                        self.messageTextField.text = ""	
                    }
                    
                }
            }
        }
    }
   
    @IBAction func LogOutButton(_ sender: Any) {
    do {
      try Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
        }
    }
    
  
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MassegeTableViewCell
        cell.label?.text =  message.body
        
        
        // Message from the cirrent user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftIV.isHidden = true
            cell .rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = #colorLiteral(red: 0.4361145794, green: 0, blue: 0, alpha: 1)
            cell.label.textAlignment = .right
        } else {
            cell .leftIV.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            cell.label.textAlignment = .left
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if (indexPath.row == 0) {
//            self.topPosition = true
//            paginate()

//            print("TOP OF TABLE!")
        } else{
//            self.topPosition = false
        }
    }
    
    
}
