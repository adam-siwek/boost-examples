trigger LeadTrigger on Lead (before insert, after insert) {
    forvendi.BoostApi.TRIGGERS.handle();
}