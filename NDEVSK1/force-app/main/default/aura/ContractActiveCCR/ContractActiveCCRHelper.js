({
	getAllActiveCCRs : function(component) {
		var action = component.get("c.getActiveCCRs");
        action.setParams({
            recId : component.get('v.recordId'),
	        });

        action.setCallback(this, function (response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                component.set("v.contactRows", resultData);                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
  }
})