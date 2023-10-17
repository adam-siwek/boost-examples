trigger ContactTrigger on Contact (after insert) {
    forvendi.BoostApi.TRIGGERS.handle();
}