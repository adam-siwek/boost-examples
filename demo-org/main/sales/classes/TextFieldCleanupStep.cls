public with sharing class TextFieldCleanupStep extends forvendi.Step {

    private Map<String, TextFieldCleanupOperation[]> cleanupConfig;

    public TextFieldCleanupStep() {
        super(TextFieldCleanupStep.class.getName());
    }

    public override void initialize() {
        deserializeStepParameters();
    }

    public override Boolean initRecordProcessing(Object rawRecord, Object rawOptionalOldRecord) {
        SObject record = (SObject)rawRecord;

        for (String fieldName : cleanupConfig.keySet()) {
            String fieldValue = (String)record.get(fieldName);
            if (String.isNotBlank(fieldValue)) {
                for (TextFieldCleanupOperation operation : cleanupConfig.get(fieldName)) {
                    fieldValue = process(fieldValue, operation);
                }
                record.put(fieldName, fieldValue);
            }
        }
        return false;
    }

    // example: {"FirstName":[{"operation":"lowercase"},{"operation":"capitalize"},{"operation":"trim"}],"LastName":[{"operation":"lowercase"},{"operation":"capitalize"},{"operation":"trim"}],"Email":[{"operation":"lowercase"},{"operation":"trim"}]}
    private void deserializeStepParameters() {
        if (cleanupConfig == null) {
            cleanupConfig = (Map<String, TextFieldCleanupOperation[]>)JSON.deserialize(getConfig().parameters, Map<String, TextFieldCleanupOperation[]>.class);
            if (cleanupConfig == null) {
                cleanupConfig = new Map<String, TextFieldCleanupOperation[]>();
            }
        }
    }

    private String process(String value, TextFieldCleanupOperation op) {
        switch on op.operation {
            when 'trim' {
                return value.trim();
            }
            when 'uppercase' {
                return value.toUpperCase();
            }
            when 'lowercase' {
                return value.toLowerCase();
            }
            when 'capitalize' {
                return value.capitalize();
            }
            when 'uncapitalize' {
                return value.uncapitalize();
            }
            when 'deletewhitespace' {
                return value.deleteWhitespace();
            }
        }
        return value;
    }

    public class TextFieldCleanupOperation {
        public String operation;
        public Decimal numberParam1;
    }
}