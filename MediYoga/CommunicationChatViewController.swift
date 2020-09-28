//
//  CommunicationChatViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 24/09/20.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Senders:SenderType {
    var senderId: String
    var displayName: String
}
struct Messages: MessageType{
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    var kind: MessageKind
    
    
}
struct Media: MediaItem{
    var placeholderImage: UIImage
    var image: UIImage?
    var size: CGSize
    var url: URL?
}
//CommunicationChatViewController
class CommunicationChatViewController: MessagesViewController,MessagesDataSource,MessageCellDelegate,MessagesLayoutDelegate,MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    let GroupAdmin:String = ""
    let currentuser = Senders(senderId: "Self", displayName: "John")
    let otheruser = Senders(senderId: "other", displayName: "Michal")

    var messages = [MessageType]()
    var textmessage:String = ""
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        iMessage()
        self.becomeFirstResponder()
        camera()
        messageInputBar.delegate = self
        messages.append(Messages(sender: otheruser,messageId: "2",sentDate: Date(),kind: .text("hi ... How Are you")))
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
//        messageInputBar.delegate = self as InputBarAccessoryViewDelegate
        
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageIncomingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: .zero))
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: .zero))


        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            
                  layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
                  layout.textMessageSizeCalculator.incomingAvatarSize = .zero
                  layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
                  layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
                  layout.attributedTextMessageSizeCalculator.incomingAvatarSize = .zero
                  layout.attributedTextMessageSizeCalculator.outgoingAvatarSize = .zero
                  layout.attributedTextMessageSizeCalculator.avatarLeadingTrailingPadding = .zero
                  layout.setMessageIncomingAvatarSize(.zero)

              }
          
//                let logoImage = UIImage.init(named: "34")
//                let logoImageView = UIImageView.init(image: logoImage)
//                logoImageView.frame = CGRect(x:0.0,y:0.0, width:40,height:40)
//                logoImageView.contentMode = .scaleAspectFit
//                let imageItem = UIBarButtonItem.init(customView: logoImageView)
//                let widthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 40)
//                let heightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 40)
//                heightConstraint.isActive = true
//                widthConstraint.isActive = true
//                navigationItem.leftBarButtonItems =  [imageItem]


                self.navigationController?.navigationBar.topItem?.title = GroupAdmin
                self.navigationItem.leftItemsSupplementBackButton = true
        let editImage    = UIImage(named: "back arrow")!
        

        let editButton   = UIBarButtonItem(image: editImage,  style: .plain, target: self, action: #selector(didTapBackButton(sender:)))



        navigationItem.leftBarButtonItems = [editButton]



    }
    
    override func viewDidLayoutSubviews() {
        messagesCollectionView.contentInset.bottom = messageInputBar.frame.height
        messagesCollectionView.scrollIndicatorInsets.bottom = messageInputBar.frame.height
    }

    @objc func didTapBackButton(sender: AnyObject){
        
//                let vc = storyboard?.instantiateViewController(identifier: "CommunicationViewController") as! CommunicationViewController
//                vc.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(vc, animated: true)
        
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil)
        
    }
    
    func iMessage() {
        defaultStyle()
        
        messageInputBar.isTranslucent = false
        messageInputBar.backgroundView.backgroundColor = .white
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        messageInputBar.inputTextView.placeholder = "Type Message"
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: true)
        messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: true)
        messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .left, animated: true)

//        messageInputBar.sendButton.imageView?.backgroundColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: true)
        messageInputBar.sendButton.image =  UIImage(systemName: "mic.circle.fill")
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 10
        messageInputBar.sendButton.imageView?.tintColor = UIColor.systemGray

        messageInputBar.sendButton.backgroundColor = .clear
        messageInputBar.textViewPadding.right = -38
    }

    
    func camera(){
        defaultStyle()
        
        messageInputBar.isTranslucent = false
        messageInputBar.backgroundView.backgroundColor = .white
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        messageInputBar.inputTextView.placeholder = "Type Message"
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: true)
        messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .left, animated: true)

//        messageInputBar.sendButton.imageView?.backgroundColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: true)
        messageInputBar.sendButton.image =  UIImage(systemName: "mic.circle")
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 10
        messageInputBar.sendButton.imageView?.tintColor = UIColor.systemGray

        messageInputBar.sendButton.backgroundColor = .clear
        messageInputBar.textViewPadding.right = -38
    }
//    func isFromCurrentSender(message: MessageType) -> Bool {
//return true
//    }
    
    func defaultStyle() {
        let newMessageInputBar = InputBarAccessoryView()
            newMessageInputBar.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        newMessageInputBar.delegate = self as! InputBarAccessoryViewDelegate
            messageInputBar = newMessageInputBar
            reloadInputViews()
        }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
            let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        }

    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
            if indexPath.item % 4 == 0 {
                return NSAttributedString(
                    string: MessageKitDateFormatter.shared.string(from: message.sentDate),
                    attributes: [
                        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                        NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1176470588, green: 0.4470588235, blue: 0.8, alpha: 1)])
            } else {
                return nil
            }
        }
        
        func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
            
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        }
        
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in  messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        let borderColor:UIColor = isFromCurrentSender(message: message) ? .clear : .clear
        return .bubbleTailOutline(borderColor, corner, .curved)
    }
    
    
    
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
            return CGSize(width: 0, height: 8)
        }
        
        func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
            if (indexPath.item) % 4 == 0 {
                return 30
            } else {
                return 0
            }
        }
    
    
        
        func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
            return 16
        }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        messages.append(Messages(sender: currentuser,messageId: "1",sentDate: Date(),kind: .text(inputBar.inputTextView.text)))
            inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)


        }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.becomeFirstResponder()

    }
   
    
    func currentSender() -> SenderType {
        return currentuser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    

  
}

