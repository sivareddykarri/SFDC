/* @Author :     Prathyusha
   @Name	 :     PhotoshootConnectionRelatedListHelper.Js
   @Created Date: FEb/15/2018
   @Description: controlls all the functions on the component  PhotoshootConnectionRelatedList
   @Version:0.2
   @Reference:*/
({
    getPhoto: function(component, event, helper) {
        var action = component.get("c.getPhotoRecords");
        action.setParams({
            "PID":component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res= JSON.parse(response.getReturnValue())
               
                component.set("v.ExtObject",res);
                component.set("v.count",res.length);
            }
        });
        $A.enqueueAction(action);
    }
})