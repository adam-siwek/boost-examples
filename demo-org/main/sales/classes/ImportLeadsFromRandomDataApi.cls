global with sharing class ImportLeadsFromRandomDataApi extends forvendi.SchedulerQueueable {

    private Integer numberOfRecords = 2;

    global ImportLeadsFromRandomDataApi() {
        super(ImportLeadsFromRandomDataApi.class.getName());
    }

    public override forvendi.SchedulerJob init() {
        if (String.isNotBlank(jobConfiguration)) {
            numberOfRecords = Math.min(Math.max(2, Integer.valueOf(jobConfiguration)), 100);
        }
        return this;
    }

    public Boolean shouldRun() {
        return true;
    }

    public override void execute(forvendi.ModificationContext ctx) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://random-data-api.com/api/v2/users?size=' + numberOfRecords);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            Account[] accounts = [SELECT Name FROM Account LIMIT 10];

            for (Object rawLead : (List<Object>)JSON.deserializeUntyped(response.getBody())) {
                Map<String, Object> lead = (Map<String, Object>)rawLead;
                Map<String, Object> address = (Map<String, Object>)lead.get('address');
                ctx.addToInsert(new Lead(
                        FirstName = ((String)lead.get('first_name')), //.toUpperCase(), //
                        LastName = ((String)lead.get('last_name')), //.toLowerCase(),   // simulation of poor data quality
                        Email = ((String)lead.get('email')), //.toUpperCase(),          //

                        MobilePhone = (String)lead.get('phone_number'),
                        Status = 'Open - Not Contacted',
                        Company = accounts[Math.max(Math.min(Integer.valueOf(Math.floor(Math.random() * accounts.size())), accounts.size() - 1), 0)].Name,
                        //Birthdate__c = Date.valueOf((String)lead.get('date_of_birth')),
                        City = (String)address.get('city'),
                        Street = (String)address.get('street_address'),
                        PostalCode = (String)address.get('zip_code')//,
                        //Country = (String)address.get('country')
                ));
            }
        } else {
            forvendi.BreezzApi.LOGGER.logError('ImportLeadsFromRandomDataApi', 'execute', response.getStatus());
        }
    }
}