trigger campEventTrigger on CAMPX__Event__c (before insert, before update) {
    if (trigger.isBefore && trigger.isInsert) {
        for(CAMPX__Event__c event : Trigger.new) {
            event.CAMPX__Status__c = 'Planning';
            event.CAMPX__StatusChangeDate__c = System.now();
        }
    }
    if (trigger.isBefore && trigger.isUpdate) {
        for(CAMPX__Event__c event : Trigger.new) {
            CAMPX__Event__c oldEvent = Trigger.oldMap.get(event.Id);
            if(event.CAMPX__Status__c != oldEvent.CAMPX__Status__c) {
                event.CAMPX__StatusChangeDate__c = System.now();
            }
        }
    }
}