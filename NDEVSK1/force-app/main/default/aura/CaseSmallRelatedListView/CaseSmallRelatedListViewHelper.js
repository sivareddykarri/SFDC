/* @Author :     Prathyusha
   @Name	 :     CaseSmallRelatedListViewHelper.Js
   @Created Date: FEb/15/2018
   @Description: controlls all the functions on the component  CaseSmallRelatedListView
   @Version:0.2
   @Reference:*/
({
	getCases : function(component) {
		var actionCas = component.get("c.getCasesWithLimit");
        actionCas.setParams({
            "recId":component.get("v.recordId"),
            "limitValue":"6"
        });
        actionCas.setCallback(this, function(response) {
            var stateRes = response.getState();
            if (stateRes === "SUCCESS") {
                component.set("v.extobj",response.getReturnValue());
                component.set("v.count",response.getReturnValue().length);
                component.set("v.countlessone",response.getReturnValue().length-1);
            }
        });
        $A.enqueueAction(actionCas);
	},
    setFlag : function(component) {
        var actionCas1 = component.get("c.setFlagTrue");
        actionCas1.setCallback(this, function(response) {
            var stateRes = response.getState();
            if (stateRes === "SUCCESS") {
                component.set("v.flag",response.getReturnValue());
            }
        });
        $A.enqueueAction(actionCas1);
    },
    showFilter:function(component,event) {
        component.set("v.loading", true);
        var evtCom = $A.get("e.force:navigateToComponent");
        evtCom.setParams({
            componentDef : "c:CaseFilterListView",
            componentAttributes: {
                "Id":component.get("v.recordId")
            }
        });
        evtCom.fire();
        component.set("v.loading", false);
    },
    crtCase:function(component, event) {
        var actionCas = component.get("c.getAccountId");
        actionCas.setParams({
            "recId":component.get("v.recordId")
        });
        actionCas.setCallback(this, function(response) {
            var stateRes = response.getState();
            if (stateRes === "SUCCESS"){
                var evtCom = $A.get("e.force:navigateToComponent");
                evtCom.setParams({
                    componentDef : "c:NewCaseQuickActionAccount",
                    componentAttributes: {
                        recordId : component.get("v.recordId"),
                        acountId : response.getReturnValue(),
                        Isconsole:true
                    }
                });
                evtCom.fire();
            }
        });
        $A.enqueueAction(actionCas);
    },
    dispCase : function (component,event) {
        component.set("v.loading", true);
        var qqAcc= event.target.getAttribute("id");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": qqAcc,
            "slideDevName": "related"
        });
        navEvt.fire();
        component.set("v.loading", false);
    }
})