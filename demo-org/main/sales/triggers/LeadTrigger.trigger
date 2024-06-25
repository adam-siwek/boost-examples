trigger LeadTrigger on Lead (before insert, after insert, before update) {
    forvendi.BreezzApi.TRIGGERS.handle();
}