trigger campEventTrigger on CAMPX__Event__c (before insert) {
    for(CAMPX__Event__c event : Trigger.new) {
        event.CAMPX__Status__c = 'Planning';
    }
}