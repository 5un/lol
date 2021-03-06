//
//  ChatViewController.swift
//  LolMate
//
//  Created by Sun on 9/17/2560 BE.
//  Copyright © 2560 TCDisrupt. All rights reserved.
//

import UIKit
import Hyphenate

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var conversation: EMConversation?
    public var conversationId: String?
    private var _dataSource: Array<EMMessageModel>?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtMessage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        conversation = EMClient.shared().chatManager.getConversation(conversationId, type: EMConversationTypeChat, createIfNotExist: true)
        conversation?.markAllMessages(asRead: nil)
        
        _dataSource = Array<EMMessageModel>()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // EMClient.shared().chatManager.add(self, delegateQueue: nil)
        // EMClient.shared().roomManager.add(self, delegateQueue: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        _loadInitialMessage()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dataSource?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = _dataSource![indexPath.row]
        
        // let CellIdentifier = EMChatBaseCell.cellIdentifier(forMessageModel: model)
        
        
        let reuseIdentifier = ((model.message?.from)! == conversationId) ? "textMessageFromMe" : "textMessageToMe"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell != nil {
            // cell = EMChatBaseCell.chatBaseCell(withMessageModel: model)
            // (cell as! EMChatBaseCell).delegate = self
            if let img = cell?.viewWithTag(1) as? UIImageView {
                img.layer.cornerRadius = 25.0
            }
            
            let view = cell?.viewWithTag(2)
            view?.layer.cornerRadius = 5.0
            
            if let lbl = view?.viewWithTag(3) as? UILabel {
                if let msg = model.message?.body as? EMTextMessageBody {
                    lbl.text = msg.text
                }
            }
            
        }
        
        // (cell as! EMChatBaseCell).set(model: model)
        
        return cell!
    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let model = _dataSource![indexPath.row]
//        return EMChatBaseCell.height(forMessageModel: model)
//    }
    
    @IBAction func btnSendMessage(_ sender: Any) {
        sendTextMessage(text: txtMessage.text!)
        txtMessage.text = ""
    }
    
    func _addMessageToDatasource(message: EMMessage) {
        let model = EMMessageModel.init(withMesage: message)
        _dataSource?.append(model)
    }
    
    func _loadInitialMessage() {
        weak var weakSelf = self
        DispatchQueue.global().async {
            var messageId = ""
            if (weakSelf?._dataSource?.count)! > 0 {
                let model = weakSelf?._dataSource?[0]
                messageId = model!.message!.messageId
            }
            
            weakSelf?.conversation?.loadMessagesStart(fromId: messageId.characters.count > 0 ? messageId : nil, count: 20, searchDirection: EMMessageSearchDirectionUp, completion: { (messages, error) in
                if error == nil {
                    for message in messages as! Array<EMMessage> {
                        let model = EMMessageModel.init(withMesage: message)
                        self._dataSource?.append(model)
                    }
                }
                
                // weakSelf?._refresh?.endRefreshing()
                
                weakSelf?.tableView.reloadData()
                
            })
        }
    }
    
    func _loadMoreMessage() {
        weak var weakSelf = self
        DispatchQueue.global().async {
            var messageId = ""
            if (weakSelf?._dataSource?.count)! > 0 {
                let model = weakSelf?._dataSource?[0]
                messageId = model!.message!.messageId
            }
            
            weakSelf?.conversation?.loadMessagesStart(fromId: messageId.characters.count > 0 ? messageId : nil, count: 20, searchDirection: EMMessageSearchDirectionUp, completion: { (messages, error) in
                if error == nil {
                    for message in messages as! Array<EMMessage> {
                        let model = EMMessageModel.init(withMesage: message)
                        self._dataSource?.insert(model, at: 0)
                    }
                }
                
                // weakSelf?._refresh?.endRefreshing()
                
                weakSelf?.tableView.reloadData()
                
            })
        }
    }
    
    func sendTextMessage(text:String) {
        let message = createTextMessage(text, to:conversation!.conversationId, EMChatTypeChat, nil)
        _sendMessage(message: message)
    }

    func createTextMessage(_ text: String, to receiver: String, _ chatType: EMChatType, _ ext: Dictionary<String, Any>?) -> EMMessage{
        let sender = EMClient.shared().currentUsername
        let body = EMTextMessageBody.init(text: text)
        let msg = EMMessage.init(conversationID: receiver, from: sender, to: receiver, body: body, ext: ext)
        
        msg!.chatType = chatType
        return msg!
    }
    
    func _sendMessage(message: EMMessage) {
        _addMessageToDatasource(message: message)
        tableView.reloadData()
        weak var weakSelf = self
        DispatchQueue.global().async {
            EMClient.shared().chatManager.send(message, progress: nil) { (message, error) in
                DispatchQueue.main.async {
                    weakSelf?.tableView.reloadData()
                    weakSelf?._scrollViewToBottom(animated: true)
                }
            }
        }
    }
    
    func _scrollViewToBottom(animated: Bool) {
        if tableView.contentSize.height > tableView.frame.height {
            let point = CGPoint(x: 0, y: tableView.contentSize.height - tableView.frame.height)
            tableView.setContentOffset(point, animated: true)
        }
    }
    
    
    
    
}
