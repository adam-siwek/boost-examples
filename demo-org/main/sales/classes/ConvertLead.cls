public class ConvertLead extends forvendi.Step {

    public ConvertLead() {
        super(ConvertLead.class.getName());
    }

    public override Boolean initRecordProcessing(Object record, Object optionalOldRecord) {
        Task newTask = (Task)record;
        getStore().requestToLoad(newTask.WhoId, new Set<String>{'IsConverted'});
        return true;
    }

    public override void finishRecordProcessing(Object record, Object optionalOldRecord) {
        Task newTask = (Task)record;
        SObject newLead = getStore().getFromStore(newTask.WhoId);
        if (newLead != null && newLead.getSObjectType() == Lead.SObjectType && !((Lead)newLead).IsConverted) {
            addAsyncJob(newTask.WhoId);
        }
    }

    public override void executeAsyncProcess(Map<String, forvendi.AsyncJobInfo> asyncJobsByRecordKey){
        Map<Id, Lead> leads = new Map<Id, Lead>([
                SELECT Company FROM Lead
                WHERE IsConverted = false
                    AND Id IN :asyncJobsByRecordKey.keySet()]);

        Set<String> companyNames = new Set<String>();
        for (Lead record : leads.values()) {
            companyNames.add(record.Company);
        }

        Map<String, Account> companyNameToAccount = new Map<String, Account>();
        for (Account acc : [SELECT Name, Id FROM Account WHERE Name IN :companyNames]) {
            companyNameToAccount.put(acc.Name, acc);
        }

        for (Lead record : leads.values()) {
            Database.LeadConvert leadConvert = new Database.LeadConvert();
            leadConvert.setLeadId(record.Id);
            if (companyNameToAccount.containsKey(record.Company)) {
                leadConvert.setAccountId(companyNameToAccount.get(record.Company).Id);
            }
            leadConvert.setConvertedStatus('Closed - Converted');
            getContext().addToConvert(leadConvert);
        }
    }

}