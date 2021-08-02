Decimal x = 60;
System.debug(Integer.valueOf(Math.round(x)));

List<String> newL = new List<String>{'1', '2','3','4','5','6','7'};
System.debug(newL[Integer.valueOf(Math.random()*newL.size())]);

String nums = '1234567890';
System.debug(nums.length());

String nums = '1234567890';
        String randMob = '';
        while (randMob.length()<7) {
            Integer randNum = Integer.valueOf(Math.random()*nums.length());
            randMob += nums.substring(randNum, randNum+1);
        }
        System.debug(randMob);


CreatingDataForTheMedicalProject.createMedicalData(2, 5);

List<Client__c> delC = [SELECT Id FROM Client__c];
delete delC;

List<Client__c> newC = [SELECT Name, (SELECT Name FROM Appointments__r) FROM Client__c];
for(Client__c cl: newC) {
    if (cl.Appointments__r != null) {
        System.debug(cl.Appointments__r.size());
    }
}

Datetime dt = System.now();
Date dateNow = dt.date().addDays(1);
System.debug(dateNow);