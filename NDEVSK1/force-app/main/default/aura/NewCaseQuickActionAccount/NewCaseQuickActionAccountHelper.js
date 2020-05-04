/* @Author: Prathyusha
   @Name: NewCaseQuickcActionAccountHelper.Js
   @Created Date: Feb/15/2018
   @Description: Controlls all the functions on the component  NewCaseQuickcActionAccount
   @Version: 0.2
   @Reference:
*/
({
    getRecTyp : function(component, event) {
        var actionRec = component.get("c.fetchRecordTypeValues");
        var optsRec = [];
        actionRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    optsRec.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.find("fetchRecordType").set("v.options", optsRec);
            }
        });
        $A.enqueueAction(actionRec);
        component.set("v.isOpen", true);
    },
    createRecT : function(component, event) {
        var actionCas = component.get("c.getSobjectName");
        actionCas.setParams({
            "recId":component.get("v.recordId")
        });
        actionCas.setCallback(this, function(response) {
            var stateRes = response.getState();
            if (stateRes === "SUCCESS") {
                var sobjN=response.getReturnValue();
                component.set("v.sobjectname",sobjN);
            }
        });
        $A.enqueueAction(actionCas);
        component.set("v.isOpen", true);
        var accId=component.get("v.recordId");
        var actionRec = component.get("c.getRecTypeId");
        var recordTypeLabel = component.find("fetchRecordType").get("v.value");
        actionRec.setParams({
            "recordTypeLabel": recordTypeLabel
        });
        actionRec.setCallback(this, function(response) {
            var stateRes = response.getState();
            if (stateRes === "SUCCESS") {
                var createRecordEvent = $A.get("e.force:createRecord");
                var recTypeID  = response.getReturnValue();
                if(component.get("v.sobjectname")==='Account'){
                    createRecordEvent.setParams({
                        "entityApiName": 'Case',
                        "recordTypeId": recTypeID,
                        "defaultFieldValues":{
                            AccountId:accId
                        }
                    });
                }
                if(component.get("v.sobjectname")==='Photo_Shoot__c'){
                    createRecordEvent.setParams({
                        "entityApiName": 'Case',
                        "recordTypeId": recTypeID,
                        "defaultFieldValues":{
                            Photo_Shoot__c:accId
                        }
                    });
                }
                if(component.get("v.sobjectname")==='Technology__c'){
                    createRecordEvent.setParams({
                        "entityApiName": 'Case',
                        "recordTypeId": recTypeID,
                        "defaultFieldValues":{
                            Technology__c:accId,
                            AccountId:component.get("v.acountId")
                        }
                    });
                }
                createRecordEvent.fire();
            }
            else if (stateRes === "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please contact your administrator"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(actionRec);
    },
    cancelTabT:function(component, event, helper) {
        
        if(component.get("v.Isconsole")){
            var workspaceAPI = component.find("workspace");
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                var focusedTabId = response.tabId;
                workspaceAPI.closeTab({tabId: focusedTabId});
            })
            .catch(function(error) {
                console.log(error);
            });
            
        }
        else{
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        }
        
    }
})