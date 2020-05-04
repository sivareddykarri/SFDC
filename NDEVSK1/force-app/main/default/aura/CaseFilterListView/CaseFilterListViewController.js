({
	 doInit: function(component, event, helper){
		helper.getCases(component, event);
   	},
    jsLoaded : function(component, event, helper){
       helper.jsLoad(component, event);
	},
    /*gotoAcc : function (component, event, helper){
        helper.goToAcc(component, event);
	},*/ 
    gotoCase : function (component, event, helper){
        helper.goToCase(component, event);
	}
})