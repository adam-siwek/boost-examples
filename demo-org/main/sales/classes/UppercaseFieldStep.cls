public with sharing class UppercaseFieldStep extends forvendi.Step {

    private String[] fieldNames = null;

    public UppercaseFieldStep() {
        super(UppercaseFieldStep.class.getName());
    }

    public override void initialize() {
        if (fieldNames == null) {
            fieldNames = (String.isBlank(getConfig().parameters) ? 'Name' : getConfig().parameters).split(',');
        }
    }

    public override Boolean initRecordProcessing(Object record, Object optionalOldRecord) {
        SObject sfRecord = (SObject)record;

        for (String fieldName : fieldNames) {
            String fieldValue = (String) sfRecord.get(fieldName);
            sfRecord.put(fieldName, String.isBlank(fieldValue) ? '' : fieldValue.trim().toLowerCase().capitalize());
        }
        return false;
    }
}