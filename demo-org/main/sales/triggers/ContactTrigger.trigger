trigger ContactTrigger on Contact (after insert, before insert) {
    forvendi.BoostApi.TRIGGERS.handle();
}