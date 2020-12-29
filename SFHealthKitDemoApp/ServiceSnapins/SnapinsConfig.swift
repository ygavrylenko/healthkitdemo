//
//  SnapinsConfig.swift
//  SnapinsSDKExample
//

import Foundation
import ServiceCore
import ServiceKnowledge
import ServiceCases
import ServiceChat
import ServiceSOS

/**
 This is a helper class that configures all the features for Snap-ins.
 */
class SnapinsConfig : NSObject {
    
    private static var config: SnapinsConfig?
    
    var knowledgeCasesConfig: SCSServiceConfiguration?
    var chatConfig: SCSChatConfiguration?
    var sosConfig: SOSOptions?
    
    /**
     Gets the singleton SnapinsConfig instance.
     */
    static var instance: SnapinsConfig {
        if (config == nil) {
            config = SnapinsConfig()
        }
        return config!
    }
    
    /**
     One time setup for the Snapins configuration.
     This is called from the AppDelegate.
     */
    func initialize() {
        initializeKnowledgeAndCases()
        initializeChat()
        initializeSOS()
        
        if (SnapinsConstants.ENABLE_CUSTOM_ACTION_BUTTONS) {
            let serviceCloud = ServiceCloud.shared()
            
            // Add self as an action button delegate
            serviceCloud.actions.delegate = self
        }
    }
    
    /**
     One time configuration for Knowledge and/or Case Management.
     */
    func initializeKnowledgeAndCases() {
        let serviceCloud = ServiceCloud.shared()
        
        // Create a configuration object for Knowledge or Cases
        // (If both are enabled, the Knowledge config will handle both situations)
        if SnapinsConstants.ENABLE_KNOWLEDGE {
            
            // Create configuration object with community url & knowledge categories
            knowledgeCasesConfig = SCSServiceConfiguration(
                community: URL(string: SnapinsConstants.COMMUNITY_URL)!,
                dataCategoryGroup: SnapinsConstants.KNOWLEDGE_CATEGORY_GROUP,
                rootDataCategory: SnapinsConstants.KNOWLEDGE_ROOT_CATEGORY)
            
            // Pass configuration to shared instance
            serviceCloud.serviceConfiguration = knowledgeCasesConfig!
        }
            
            // Only need to make this call if Knowledge ISN'T enabled but Cases is...
        else if SnapinsConstants.ENABLE_CASES {
            
            // Create configuration object with community url
            knowledgeCasesConfig = SCSServiceConfiguration(community: URL(string: SnapinsConstants.COMMUNITY_URL)!)
            
            // Pass configuration to shared instance
            serviceCloud.serviceConfiguration = knowledgeCasesConfig!
        }
        
        // We also need to assign a Quick Action for Cases...
        if SnapinsConstants.ENABLE_CASES {
            // Set the Case Mgmt Quick Action
            serviceCloud.cases.caseCreateActionName = SnapinsConstants.CASES_QUICK_ACTION
        }
    }
    
    /**
     One time configuration for Chat.
     */
    func initializeChat() {
        let serviceCloud = ServiceCloud.shared()
        
        if SnapinsConstants.ENABLE_CHAT {
            
            // Create a configuration object for Chat
            chatConfig = SCSChatConfiguration(liveAgentPod: SnapinsConstants.CHAT_POD_NAME,
                                              orgId: SnapinsConstants.CHAT_ORG_ID,
                                              deploymentId: SnapinsConstants.CHAT_DEPLOYMENT_ID,
                                              buttonId: SnapinsConstants.CHAT_BUTTON_ID)
            
            // Add support for pre-chat fields
            if (SnapinsConstants.ENABLE_PRECHAT_FIELDS) {
                configurePrechat(config: chatConfig)
            }
            
            // Add self as a chat delegate
            serviceCloud.chatCore.add(delegate: self)
        }
    }
    
    /**
     Configures pre-chat data for Chat.
     */
    func configurePrechat(config: SCSChatConfiguration?) {
        
        // Create some basic pre-chat fields (with user input)
        let firstNameField = SCSPrechatTextInputObject(label: "First Name")
        firstNameField!.isRequired = true
        let lastNameField = SCSPrechatTextInputObject(label: "Last Name")
        lastNameField!.isRequired = true
        let emailField = SCSPrechatTextInputObject(label: "Email")
        emailField!.isRequired = true
        emailField!.keyboardType = .emailAddress
        emailField!.autocorrectionType = .no
        
        // Create a pre-chat field without user input
        // (This illustrates a good way to directly send data to your org.)
        let subjectField = SCSPrechatObject(label: "Subject", value: "Chat case created by app")
        
        // Update config object with the pre-chat fields
        config?.prechatFields =
            [firstNameField, lastNameField, emailField, subjectField] as? [SCSPrechatObject]

        // Create an entity mapping for a Contact record type
        // (All this entity stuff is only required if you
        // want to map transcript fields to other Salesforce records.)
        let contactEntity = SCSPrechatEntity(entityName: "Contact")
        contactEntity.saveToTranscript = "Contact"
        contactEntity.linkToEntityName = "Case"
        contactEntity.linkToEntityField = "ContactId"
        
        // Add some field mappings to our Contact record
        let firstNameEntityField = SCSPrechatEntityField(fieldName: "FirstName", label: "First Name")
        firstNameEntityField.doFind = true
        firstNameEntityField.isExactMatch = true
        firstNameEntityField.doCreate = true
        contactEntity.entityFieldsMaps.add(firstNameEntityField)
        let lastNameEntityField = SCSPrechatEntityField(fieldName: "LastName", label: "Last Name")
        lastNameEntityField.doFind = true
        lastNameEntityField.isExactMatch = true
        lastNameEntityField.doCreate = true
        contactEntity.entityFieldsMaps.add(lastNameEntityField)
        let emailEntityField = SCSPrechatEntityField(fieldName: "Email", label: "Email")
        emailEntityField.doFind = true
        emailEntityField.isExactMatch = true
        emailEntityField.doCreate = true
        contactEntity.entityFieldsMaps.add(emailEntityField)
        
        // Create an entity mapping for a Case record type
        let caseEntity = SCSPrechatEntity(entityName: "Case")
        caseEntity.saveToTranscript = "Case"
        caseEntity.showOnCreate = true
        
        // Add one field mappings to our Case record
        let subjectEntityField = SCSPrechatEntityField(fieldName: "Subject", label: "Subject")
        subjectEntityField.doCreate = true
        caseEntity.entityFieldsMaps.add(subjectEntityField)
        
        // Update config object with the entity mappings
        // (This is only required if you want to map transcript
        // fields to other Salesforce records.)
        config?.prechatEntities = [contactEntity, caseEntity]
    }
    
    /**
     One time configuration for SOS.
     */
    func initializeSOS() {
        let serviceCloud = ServiceCloud.shared()
        
        if SnapinsConstants.ENABLE_SOS {
            
            // Create a configuration object for SOS
            sosConfig = SOSOptions(liveAgentPod: SnapinsConstants.SOS_POD_NAME,
                                   orgId: SnapinsConstants.SOS_ORG_ID,
                                   deploymentId: SnapinsConstants.SOS_DEPLOYMENT_ID)
            
            // Add self as an SOS delegate
            serviceCloud.sos.add(self)
        }
    }
}
