public class CreatingDataForTheMedicalProject {
    private static List<String> firstNames = new List<String>{
        'Dmitry', 'Arseniy', 'Nikolay', 'Artem', 
        'Vasia', 'Kirill', 'Tolia', 'Nadia', 'Vika', 'Aleksandra', 'Rosa', 'Valentina',
        'Ksenia', 'Georgiy'
    };
    private static List<String> lastNames = new List<String>{
        'Sanko', 'Kekovich', 'Hehehovich', 'Fursa', 
        'Korshun', 'Astapko', 'Shuk', 'Fera', 'Ludko', 'Shapito', 'Karnaval', 'Oshenko',
        'Ktotam', 'Lolovich'
    };
    private static List<String> phoneCodesWithOperators = new List<String>{
        '+37525', '+93701', '+35569', '+21370', 
        '+54320', '+37491', '+43660', '+99450', '+97339', '+88018', '+32484', '+22997',
        '+38765', '+35998'
    };
    private static List<String> mails = new List<String>{
        '@mail.ru', '@icloud.com', '@gmail.com', '@yandex.ru', 
        '@vrp.com', '@kek.com', '@yoohoo.com', '@amazon.com', '@ozone.ru'
    };
    private static List<Client__c> newClientList = new List<Client__c>();
    private static List<Appointment__c> newAppointList = new List<Appointment__c>();
    private static List<Service__c> serviceList = [SELECT Name, Price__c FROM Service__c];
    private static Map<Id, Date> datesCounter = new Map<Id, Date>();

    public static String createMobile() {
        String nums = '1234567890';
        String randMob = '';
        while (randMob.length()<7) {
            Integer randNum = Integer.valueOf(Math.random()*nums.length());
            randMob += nums.substring(randNum, randNum+1);
        }
        return randMob;
    }

    public static void listOfAppointments(Integer i) {
        Integer randomNumOfService = Integer.valueOf(Math.random()*serviceList.size()); 
        Appointment__c newAppoint = new Appointment__c();
        newAppoint.Name = newClientList[i].Name + ' ' + serviceList[randomNumOfService].Name;
        newAppoint.Client__c = newClientList[i].Id;
        newAppoint.Service__c = serviceList[randomNumOfService].Id;
        if (newClientList[i].VIP__c) {
            newAppoint.Payed__c = serviceList[randomNumOfService].Price__c * 0.8;
        } else {
            newAppoint.Payed__c = serviceList[randomNumOfService].Price__c;
        }
        if (datesCounter.get(newClientList[i].Id) == null) {
            Datetime dt = System.now();
            Date dateNow =  dt.date();
            newAppoint.Date__c = dateNow;
            datesCounter.put(newClientList[i].Id, dateNow);
        } else {
            Date newDate = datesCounter.get(newClientList[i].Id).addDays(Integer.valueOf(Math.random()*4)*7);
            newAppoint.Date__c = newDate;
            datesCounter.put(newClientList[i].Id, newDate);
        }
        newAppointList.add(newAppoint);
    }

    public static void createMedicalData(Integer amountOfClients, Integer amountOfAppointments) {
        Integer countForClientsEmailAndMobile = 1;
        Integer countForClientsVIP = 1;
        Integer countForRemainingAppoint = 1;
        for (Integer i = 0; i < amountOfClients; i++) {
            Client__c newClient = new Client__c();
            newClient.Name = firstNames.get(Integer.valueOf(Math.random()*lastNames.size())) + ' ' + lastNames.get(Integer.valueOf(Math.random()*lastNames.size()));
            newClient.Age__c = Integer.valueOf(Math.random()*90);
            newClientList.add(newClient);
        }
        do {
            Integer randomNumOfClient = Integer.valueOf(Math.random()*amountOfClients);
            if(newClientList[randomNumOfClient].Mobile__c == null) {
                newClientList[randomNumOfClient].Mobile__c = phoneCodesWithOperators.get(Integer.valueOf(Math.random()*phoneCodesWithOperators.size())) + createMobile();
                newClientList[randomNumOfClient].Email__c = lastNames.get(Integer.valueOf(Math.random()*lastNames.size())) + firstNames.get(Integer.valueOf(Math.random()*firstNames.size())) + mails.get(Integer.valueOf(Math.random()*mails.size()));
                countForClientsEmailAndMobile++;
            }
        } while (countForClientsEmailAndMobile <= Integer.valueOf(Math.round(amountOfClients*0.6))); //60% клиентов

        do {
            Integer randomNumOfClient = Integer.valueOf(Math.random()*amountOfClients);
            if(newClientList[randomNumOfClient].VIP__c == false) {
                newClientList[randomNumOfClient].VIP__c = true;
                countForClientsVIP++;
            }
        } while (countForClientsVIP <= Integer.valueOf(Math.round(amountOfClients*0.15)));

        insert newClientList;

        for (Integer i = 0; i < amountOfClients; i++) {
            listOfAppointments(i);
        }
        do {
            listOfAppointments(Integer.valueOf(Math.random()*amountOfClients));
            countForRemainingAppoint++;
        } while (countForRemainingAppoint <= amountOfAppointments - amountOfClients);
        insert newAppointList;
    }
}
