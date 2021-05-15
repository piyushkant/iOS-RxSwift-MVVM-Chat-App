//
//  APIService.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import RxSwift
import RxCocoa

final class APIService: APIServiceProtocol {
    
    static let shared = APIService()
    
    var disposeBag = DisposeBag()
    
    let firestoreUsers = Firestore.firestore().collection("users")
    let firestoreMessages = Firestore.firestore().collection("messages")
    let firestorePush = Firestore.firestore().collection("push")
    
    private init() { }
    
    func fetchUser(uid: String) -> Observable<User?> {
        return Observable.create { (observer) -> Disposable in
            self.firestoreUsers.document(uid).getDocument { (snapshot, error) in
                guard let dic = snapshot?.data(),
                      let user = User(user: dic) else { return }
                observer.onNext(user)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func fetchUsers() -> Observable<[User]> {
        return Observable<[User]>.create { (observer) -> Disposable in
            self.firestoreUsers.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Failed to fetch users:", error)
                    observer.onError(error)
                    return
                }
                
                var users = [User]()
                snapshot?.documents.forEach({ doc in
                    let json = doc.data()
                    guard let user = User(user: json),
                          user.uid != Auth.auth().currentUser?.uid else { return }
                    users.append(user)
                })
                
                observer.onNext(users)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func fetchConversations() -> Observable<[Conversation]> {
        guard let uid = Auth.auth().currentUser?.uid else { return Observable.empty() }
        let ref = self.firestoreMessages.document(uid).collection("recent-messages").order(by: "timestamp")
        var conversations = [Conversation]()
        var sortedConversations = [Conversation]()
        return Observable.create { (observer) -> Disposable in
            ref.addSnapshotListener { (snapshot, error) in
                
                snapshot?.documentChanges.forEach({ (change) in
                    let dic = change.document.data()
                    let message = Message(dic: dic)
                    let id = message.toId == uid ? message.fromId : message.toId
                    
                    if conversations.contains(where: {$0.user.uid == id}) {
                        conversations.removeAll(where: {$0.user.uid == id})
                    }
                    
                    self.fetchUser(uid: id)
                        .subscribe(onNext:{ user -> Void in
                            guard let data = user else { return }
                            let conversation = Conversation(user: data, recentMessage: message)
                            conversations.insert(conversation, at: 0)
                            sortedConversations = conversations.sorted(by: {$0.recentMessage.timestamp.dateValue() > $1.recentMessage.timestamp.dateValue()})
                            observer.onNext(sortedConversations)
                        })
                        .disposed(by: self.disposeBag)
                })
            }
            
            return Disposables.create {
                observer.onCompleted()
            }
        }
    }
    
    func fetchMessages(forUser user: User) -> Observable<[Message]> {
        guard let currentUid = Auth.auth().currentUser?.uid else { return Observable.empty() }
        var messages = [Message]()
        return Observable.create { (observer) -> Disposable in
            let query = self.firestoreMessages.document(currentUid).collection(user.uid).order(by: "timestamp")
            
            query.addSnapshotListener { (snapshot, error) in
                snapshot?.documentChanges.forEach({ (change) in
                    if change.type == .added {
                        let dic = change.document.data()
                        messages.append(Message(dic: dic))
                    }
                })
                observer.onNext(messages)
            }
            
            return Disposables.create {
                observer.onCompleted()
            }
        }
    }
    
    func uploadMessage(_ text: String, To user: User?) -> Observable<Bool> {
        guard let currentUid = Auth.auth().currentUser?.uid, let user = user else { return Observable.just(false)}
        
        let message: [String: Any] = [
            "text": text,
            "fromId": currentUid,
            "toId": user.uid,
            "timestamp": Timestamp(date: Date())
        ]
        
        return Observable.create { (observer) -> Disposable in
            self.firestoreMessages.document(currentUid).collection(user.uid).addDocument(data: message) { (_) in
                self.firestoreMessages.document(user.uid).collection(currentUid).addDocument(data: message) { (_) in
                    self.firestoreMessages.document(currentUid).collection("recent-messages").document(user.uid).setData(message)
                    self.firestoreMessages.document(user.uid).collection("recent-messages").document(currentUid).setData(message)
                    
                    self.fetchPushData(forUser: user)
                        .subscribe(onNext: {
                            
                            let token = $0.token
                            let title = String(describing: Auth.auth().currentUser?.email ?? "ChatX Friend")
                            let body = text
                            
                            self.sendPushNotification(to: token, title: title, body: body)
                                .subscribe( onNext: {
                                    print("Sent push notification: \($0)")
                                })
                                .disposed(by: self.disposeBag)
                        })
                        .disposed(by: self.disposeBag)
                    
                    observer.onNext(true)
                }
            }
            return Disposables.create{
                observer.onCompleted()
            }
        }
    }
    
    func sendPushNotification(to token: String, title: String, body: String)-> Observable<Bool> {
        let urlString = EndPoint.send.url.absoluteString
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token, "notification" : ["title" : title, "body" : body], "data" : ["user" : "test_id"]]
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let serverKey = PropertyUtils.getValue(fileName: "Push-Info", key: "gcm_server_key")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        
        return Observable.create { (observer) -> Disposable in
            let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
                do {
                    if let jsonData = data {
                        if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                            NSLog("Received data:\n\(jsonDataDict))")
                            observer.onNext(true)
                        }
                    }
                } catch let err as NSError {
                    print(err.debugDescription)
                    observer.onNext(false)
                }
            }
            task.resume()
            
            return Disposables.create{
                observer.onCompleted()
            }
        }
    }
    
    func uploadPushData(token: String) -> Observable<Bool> {
        guard let uid = Auth.auth().currentUser?.uid, let email = Auth.auth().currentUser?.email else {return Observable.just(false)}
        
        let push: [String: Any] = [
            "email": email,
            "token": token,
        ]
        
        return Observable<Bool>.create { (observer) -> Disposable in
            self.firestorePush.document(uid).setData(push) { (error) in
                if let error = error {
                    print("Failed to upload push data: ", error)
                    observer.onNext(false)
                    return
                }
                observer.onNext(true)
            }
            return Disposables.create()
        }
    }
    
    func fetchPushData(forUser user: User) -> Observable<Push> {
        let uid = user.uid
        
        return Observable.create { (observer) -> Disposable in
            self.firestorePush.document(uid).getDocument { (snapshot, error) in
                guard let dic = snapshot?.data(), let email = dic["email"], let token = dic["token"] else {return}
                
                observer.onNext(Push(email: String(describing: email), token: String(describing: token)))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
