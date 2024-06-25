Database.delete([SELECT Id FROM Entitlement LIMIT 1000], false);
Database.delete([SELECT Id FROM Task LIMIT 1000], false);
Database.delete([SELECT Id FROM Event LIMIT 1000], false);
Database.delete([SELECT Id FROM Lead LIMIT 1000], false);
Database.delete([SELECT Id FROM Case LIMIT 1000], false);
Database.delete([SELECT Id FROM Contact LIMIT 1000], false);
Database.delete([SELECT Id FROM Opportunity LIMIT 1000], false);
Database.delete([SELECT Id FROM Account LIMIT 1000], false);

Database.delete([SELECT Id FROM forvendi__B_Log__c LIMIT 1000], false);
Database.delete([SELECT Id FROM forvendi__B_Metric__c LIMIT 1000], false);
Database.delete([SELECT Id FROM forvendi__B_AsyncJob__c LIMIT 1000], false);
Database.delete([SELECT Id FROM forvendi__B_DelayedAsyncJob__c LIMIT 1000], false);

