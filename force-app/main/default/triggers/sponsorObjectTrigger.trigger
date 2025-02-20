trigger sponsorObjectTrigger on CAMPX__Sponsor__c (before insert, before update) {

    for(CAMPX__Sponsor__c sponsor : Trigger.new){
// BeforeInsert Trigger
        if(trigger.isBefore && trigger.isInsert){

        if(sponsor.CAMPX__Status__c == null){
            sponsor.CAMPX__Status__c = 'Pending';
        }

// if Email is empty, display error.
        if(sponsor.CAMPX__Email__c == null){
            sponsor.addError('A sponsor can not be created without an email address');
        }

// Set Sponsor Tier to Bronze, Silver, or Gold based on their contribution amount.
        if(sponsor.CAMPX__ContributionAmount__c > 0 && sponsor.CAMPX__ContributionAmount__c < 1000){
            sponsor.CAMPX__Tier__c = 'Bronze';
        }
        else if(sponsor.CAMPX__ContributionAmount__c >= 1000 && sponsor.CAMPX__ContributionAmount__c < 5000){
            sponsor.CAMPX__Tier__c = 'Silver';
        }
        else if(sponsor.CAMPX__ContributionAmount__c > 5000){
            sponsor.CAMPX__Tier__c = 'Gold';
        }
        else{
            sponsor.CAMPX__Tier__c = null;
        }

// If CAMPX__Status__c is updated to Accepted before CAMPX___Event__c is populated, display error.
        if(sponsor.CAMPX__Status__c == 'Accepted' && sponsor.CAMPX__Event__c == null){
            sponsor.addError('A Sponsor must be associated with an event before being Accepted.');
        }
    }

// BeforeUpdate Trigger
        if(trigger.isBefore && trigger.isUpdate){
            CAMPX__Sponsor__c oldSponsor = Trigger.oldMap.get(sponsor.Id);
// if CAMPX__Status__c is updated to Accepted before CAMPX___Event__c is populated, display error.
            if(sponsor.CAMPX__Status__c != oldSponsor.CAMPX__Status__c && sponsor.CAMPX__Status__c == 'Accepted' && sponsor.CAMPX__Event__c == null){
                sponsor.addError('A Sponsor must be associated with an event before being Accepted.');
            }
        }
    }
}