({
    getCases : function(component, event) {
        var actionCas = component.get("c.getCasesWithLimit");
       
        actionCas.setParams({
            
            "recId":component.get("v.Id"),
            "limitValue":"20000"
        });
        actionCas.setCallback(this, function(response) {
            var stateRes = response.getState();
            
            if (stateRes === "SUCCESS") {
                component.set("v.extobj",response.getReturnValue());
                component.set("v.count",response.getReturnValue().length);
                //this.jsLoad(component, event);
                 //component.set("v.Spinner", false); 
            }
        });
        $A.enqueueAction(actionCas);
        var workSpaceAPI = component.find("workspace");
        workSpaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workSpaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: 'Case Related List'
            });
        })
        .catch(function(error) {
            console.log(error);
        });
     
    },
    jsLoad : function(component, event) {  
          setTimeout(function(){ 
        //$.noConflict();
            $(document).ready(function() {
    // Setup - add a text input to each footer cell
    $('#sampleTable tfoot th').each( function () {
        var title = $(this).text();
        $(this).html( '<input type="text" placeholder="'+title+'" />' );
    } );
 
    // DataTable
    var table = $('#sampleTable').DataTable();
 
    // Apply the search
    table.columns().every( function () {
        var that = this;
 
        $( 'input', this.footer() ).on( 'keyup change', function () {
            if ( that.search() !== this.value ) {
                that
                    .search( this.value )
                    .draw();
            }
        } );
    } );
} );
 component.set("v.Spinner", false); }, 3000);       
  },
 
    goToCase : function(component, event) {
        component.set("v.loading", true);
        var qQ1= event.target.getAttribute("id");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": qQ1,
            "slideDevName": "related"
        });
        navEvt.fire();
        component.set("v.loading", false);
    }
})