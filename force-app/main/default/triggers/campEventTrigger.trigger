trigger campEventTrigger on CAMPX__Event__c (before insert, before update) {
    // BeforeInsert Trigger
    if (trigger.isBefore && trigger.isInsert) {
        for(CAMPX__Event__c event : Trigger.new) {
            // If CAMPX__Status__c is anything other than Planning upon creation, set it to Planning.
            event.CAMPX__Status__c = 'Planning';
            event.CAMPX__StatusChangeDate__c = System.now();

            // Calculate revenue formula.
            Decimal revenueFormula;
            if (event.CAMPX__GrossRevenue__c != null && event.CAMPX__TotalExpenses__c != null) {
                revenueFormula = event.CAMPX__GrossRevenue__c - event.CAMPX__TotalExpenses__c;
            } else {
                revenueFormula = null;
            }
            
            // Enforce that CAMPX__NetRevenue__c is always equal to the difference between CAMPX__GrossRevenue__c and CAMPX__TotalExpenses__c.
            if (event.CAMPX__NetRevenue__c != revenueFormula && event.CAMPX__GrossRevenue__c != null && event.CAMPX__TotalExpenses__c != null) {
                event.CAMPX__NetRevenue__c = revenueFormula;
            }
            else if (event.CAMPX__GrossRevenue__c == null || event.CAMPX__TotalExpenses__c == null) {
                event.CAMPX__NetRevenue__c = null;
            }
        }
    }

    // BeforeUpdate Trigger
    if (trigger.isBefore && trigger.isUpdate) {
        for(CAMPX__Event__c event : Trigger.new) {
            // Set prior record values to compare.
            CAMPX__Event__c oldEvent = Trigger.oldMap.get(event.Id);
            
            // Calculate revenue formula.
            Decimal revenueFormula;
            if (event.CAMPX__GrossRevenue__c != null && event.CAMPX__TotalExpenses__c != null) {
                revenueFormula = event.CAMPX__GrossRevenue__c - event.CAMPX__TotalExpenses__c;
            } else {
                revenueFormula = null;
            }

            // If CAMPX__Status__c is updated, update CAMPX__StatusChangeDate__c.
            if(event.CAMPX__Status__c != oldEvent.CAMPX__Status__c) {
                event.CAMPX__StatusChangeDate__c = System.now();
            }

            // Enforce that CAMPX__NetRevenue__c is always equal to the difference between CAMPX__GrossRevenue__c and CAMPX__TotalExpenses__c.
            if (event.CAMPX__NetRevenue__c != revenueFormula && event.CAMPX__GrossRevenue__c != null && event.CAMPX__TotalExpenses__c != null) {
                event.CAMPX__NetRevenue__c = revenueFormula;
            }
            else if (event.CAMPX__GrossRevenue__c == null || event.CAMPX__TotalExpenses__c == null) {
                event.CAMPX__NetRevenue__c = null;
            }
        }
    }
}