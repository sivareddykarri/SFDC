/* @Author: Vazeer Mohammed
   @Name: Opportunity_IntegrationHelper.Js
   @Created Date: May/15/2019
   @Description: Helper Class for the Opportunity_Integration Component
   @Version: 0.2
   @Reference:
*/
({
    getOppDetailsValidation : function(component) {
        var action = component.get("c.getOppDetailsWithUserAccess");
        action.setParams({
            "recId":component.get("v.recordId"),
        });
        action.setCallback(this, function(response) {
            var stateRes = response.getState();
            if (stateRes === "SUCCESS") {
                var oppDetails = response.getReturnValue();
                //Opp Stage Validation
                if(!oppDetails.access && (oppDetails.opp.StageName=='Contract Signed' || oppDetails.opp.StageName=='Closed Won' || oppDetails.opp.StageName=='Closed Lost')){
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type" : "error",
                        "message": "Opportunity and PIP Requests (if any) have been synchronized with Legacy at this stage of the Opportunity lifecycle. Therefore no new Send to Legacy requests are allowed.",
                         mode: 'sticky'
                    });
                    toastEvent.fire();
                }
                //PIP Data Validation
                if(oppDetails.oppBrandSize >= 1){
                    var dynamicErrorPIPFields;
                    if($A.util.isUndefinedOrNull(oppDetails.opp.PIP_Contact_Name__c)){
                        dynamicErrorPIPFields= 'PIP Contact Name';
                    }
                    if($A.util.isUndefinedOrNull(oppDetails.opp.PIP_Contact_Phone__c)){
                        dynamicErrorPIPFields = !dynamicErrorPIPFields ? 'PIP Contact Phone' : dynamicErrorPIPFields+', PIP Contact Phone';
                    }
                    if($A.util.isUndefinedOrNull(oppDetails.opp.Inspection_Reason__c)){
                        dynamicErrorPIPFields = !dynamicErrorPIPFields ? 'Inspection Reason' : dynamicErrorPIPFields+', Inspection Reason';
                    }
                    if($A.util.isUndefinedOrNull(oppDetails.opp.Inspection_Type__c)){
                        dynamicErrorPIPFields = !dynamicErrorPIPFields ? 'Inspection Type' : dynamicErrorPIPFields+', Inspection Type';
                    }
                    if($A.util.isUndefinedOrNull(oppDetails.opp.Split_Property__c)){
                        dynamicErrorPIPFields = !dynamicErrorPIPFields ? 'Split Property' : dynamicErrorPIPFields+', Split Property';
                    }
                    if($A.util.isUndefinedOrNull(oppDetails.opp.Owner.Phone)){
                        dynamicErrorPIPFields = !dynamicErrorPIPFields ? 'Owner Phone' : dynamicErrorPIPFields+', Owner Phone';
                    }
                    if($A.util.isUndefinedOrNull(oppDetails.opp.Current_Brand__c)){
                        dynamicErrorPIPFields = !dynamicErrorPIPFields ? 'Property Current Parent Company' : dynamicErrorPIPFields+', Property Current Parent Company';
                    }
                    if(dynamicErrorPIPFields){
                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message: 'PIP Request requires the following field(s): '+ dynamicErrorPIPFields,
                            key: 'info_alt',
                            type: 'error',
                            mode: 'sticky'
                        });
                        toastEvent.fire();
                    }
                }
                //Opportunity Validation
                var dynamicErrorOppFields;
                if($A.util.isUndefinedOrNull(oppDetails.opp.Anticipated_Room_Count__c)){
                    dynamicErrorOppFields= 'Anticipated Room Count';
                }
                if($A.util.isUndefinedOrNull(oppDetails.opp.Anticipated_Opening_Date__c)){
                    dynamicErrorOppFields = !dynamicErrorOppFields ? 'Anticipated Opening Date' : dynamicErrorOppFields+', Anticipated Opening Date';
                }
                if($A.util.isUndefinedOrNull(oppDetails.opp.Property_Street__c)){
                    dynamicErrorOppFields = !dynamicErrorOppFields ? 'Property Street' : dynamicErrorOppFields+', Property Street';
                }
                if($A.util.isUndefinedOrNull(oppDetails.opp.Property_City__c)){
                    dynamicErrorOppFields = !dynamicErrorOppFields ? 'Property City' : dynamicErrorOppFields+', Property City';
                }
                if($A.util.isUndefinedOrNull(oppDetails.opp.Property_Country__c)){
                    dynamicErrorOppFields = !dynamicErrorOppFields ? 'Property Country, Property State/Province, Intl Property State/Province' : dynamicErrorOppFields+', Property Country, Property State/Province, Intl Property State/Province';
                }
                if((oppDetails.opp.Property_Country__c=='United States' || oppDetails.opp.Property_Country__c=='Canada') && $A.util.isUndefinedOrNull(oppDetails.opp.Property_State_Province__c)){
                    dynamicErrorOppFields = !dynamicErrorOppFields ? 'Property State/Province' : dynamicErrorOppFields+', Property State/Province';
                }else if(!$A.util.isUndefinedOrNull(oppDetails.opp.Property_Country__c) && oppDetails.opp.Property_Country__c!='United States' && oppDetails.opp.Property_Country__c!='Canada' && $A.util.isUndefinedOrNull(oppDetails.opp.Intl_Property_State_Province__c)){
                    dynamicErrorOppFields = !dynamicErrorOppFields ? 'Intl Property State/Province' : dynamicErrorOppFields+', Intl Property State/Province';
                }
                if($A.util.isUndefinedOrNull(oppDetails.opp.Property_Zip_Postal_Code__c)){
                    dynamicErrorOppFields = !dynamicErrorOppFields ? 'Property Zip/Postal Code' : dynamicErrorOppFields+', Property Zip/Postal Code';
                }
                if($A.util.isUndefinedOrNull(oppDetails.opp.CloseDate)){
                    dynamicErrorOppFields = !dynamicErrorOppFields ? 'Close Date' : dynamicErrorOppFields+', Close Date';
                }
                if($A.util.isUndefinedOrNull(oppDetails.opp.Deal_Type__c)){
                    dynamicErrorOppFields = !dynamicErrorOppFields ? 'Deal Type' : dynamicErrorOppFields+', Deal Type';
                }
                if($A.util.isUndefinedOrNull(oppDetails.opp.Management_Probability__c)){
                    dynamicErrorOppFields = !dynamicErrorOppFields ? 'Management Probability' : dynamicErrorOppFields+', Management Probability';
                }
                if($A.util.isUndefinedOrNull(oppDetails.opp.Managed_Franchised__c)){
                    dynamicErrorOppFields = !dynamicErrorOppFields ? 'Managed/Franchised' : dynamicErrorOppFields+', Managed/Franchised';
                }
                if($A.util.isUndefinedOrNull(oppDetails.opp.Region_and_Sub_Region__c)){
                    dynamicErrorOppFields = !dynamicErrorOppFields ? 'Region' : dynamicErrorOppFields+', Region';
                }
                if(dynamicErrorOppFields){
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message:'Opportunity Request requires the following field(s): '+ dynamicErrorOppFields,
                        key: 'info_alt',
                        type: 'error',
                        mode: 'sticky'
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
    getOppBrandDetailsValidation : function(component) {
        var action = component.get("c.getOppBrandSize");
        action.setParams({
            "recId":component.get("v.recordId"),
        });
        action.setCallback(this, function(response) {
            var stateRes = response.getState();
            if (stateRes === "SUCCESS") {
                var oppBrandSize = response.getReturnValue();
                if(oppBrandSize==0){
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type" : "error",
                        "message": "There must be at least one Opportunity Brand selected (Request Opportunity) to send the Opportunity to Legacy.",
                         mode: 'sticky'
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
    sendToLegacyRes : function(component) {
        component.set("v.showSpinner",true);
        var actionOpp = component.get("c.sendToLegacy");
        actionOpp.setParams({
            "recId" : component.get("v.recordId")
        });
        actionOpp.setCallback(this, function(response) {
            component.set("v.showSpinner",false);
            var stateRes = response.getState();
            
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            var toastEvent = $A.get("e.force:showToast");
            
            if (stateRes === "SUCCESS") {
                var status = response.getReturnValue();
                console.log('State success--->' + response.getReturnValue());
                if(status =='success'){
                    toastEvent.setParams({
                        "type" : "Success",
                        "message": "Opportunity/PIP request(s) has been sent to Legacy successfully"
                    });
                }else if(status =='Legacy Error'){
                    toastEvent.setParams({
                        "type" : "error",
                        "mode" : 'sticky',
                        "message": "An error occurred when processing your request. A Salesforce Administrator has been notified for resolution of this error"
                    });
                }
            }else if(stateRes === "ERROR"){
                console.log('State Error');
                toastEvent.setParams({
                    "title" : 'Error Message',
                    "type" : "error",
                    "mode" : 'sticky',
                    "message": "An error occurred when processing your request. Try resubmitting this request after 15 minutes."
                });                    
            }
            toastEvent.fire();
        });
        $A.enqueueAction(actionOpp);
    }
})