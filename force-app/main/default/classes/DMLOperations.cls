/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Tyler Riden
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account newAccount = new Account();
        // Set some fields on the Account
        newAccount.BillingCity = 'Chattanooga';
        newAccount.NumberOfEmployees = 10;
        newAccount.Name = 'Test Account';
        // Insert the Account into the database
        insert newAccount;
        // Return the Id of the newly created Account
        return newAccount.Id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account account1 = new Account();
        account1.Name = name;
        account1.Industry = industry;
        // Insert the Account
        insert account1;
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact newContact = new Contact();
        // Set some fields on the Contact
        newContact.LastName = 'Contact';
        newContact.FirstName = 'Test';
        newContact.Email = 'test@test.com';
        // Set the AccountId field to the given accountId
        newContact.AccountId = accountId;
        // Insert the Contact into the database
        insert newContact;
        // Return the Id of the newly created Contact
        return newContact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        Contact contact1 = [SELECT Id FROM Contact WHERE Id = :contactId];
        // [SELECT Id FROM Contact WHERE Id = :contactId]

        // Update the Contact's last name
        contact1.LastName = newLastName;
        // Update the Contact in the database
        update contact1;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Id = :oppId];
        // [SELECT Id FROM Opportunity WHERE Id = :oppId]

        // Update the Opportunity's stage
        opp.StageName = newStage;
        // Update the Opportunity in the database
        update opp;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        Account account1 = [SELECT Id FROM Account WHERE Id = :accountId];
        // [SELECT Id FROM Account WHERE Id = :accountId]

        // Update the Account with the given Id with the new name and industry
        account1.Name = newName;
        account1.Industry = newIndustry;
        update account1;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        List<Opportunity> oppUpdateList = new List<Opportunity>();
        // Iterate over the opportunities
        for(Opportunity opp : opportunities){
            opp.StageName = 'Qualification';
            opp.CloseDate = Date.today().addMonths(3);
            opp.Amount = 50000;
            oppUpdateList.add(opp);
        }
            // Set the Opportunity's Stage to Qualification
            // Set the Opportunity's Close Date to 3 months from today
            // Set the Opportunity's Amount to 50000

        // Upsert the Opportunity
        upsert oppUpdateList;
    }

    /**
     * Question 8
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        //Find Account
        Id accountId;
        List<Account> accList = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];
                if(accList.isEmpty()){
                    Account newAcc = new Account();
                    newAcc.Name = accountName;
                    insert newAcc;
                    accountId = newAcc.Id;
                }

            
            
        System.debug(accountId);

        List<Opportunity> oppList = new List<Opportunity>();
        // Loop through each Opportunity name
        for(String oppName : oppNames){
            // Create an Opportunity with the given name
            Opportunity newOpp = new Opportunity();
            newOpp.Name = oppName;
            newOpp.AccountId = accountId;
            newOpp.StageName = 'New';
            newOpp.CloseDate = Date.today().addMonths(3);
            System.debug(newOpp);
            // Add the Opportunity to the list
            oppList.add(newOpp);
            System.debug(oppList);
        }           
        // Upsert opps
        upsert oppList;
    }
    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
       List<Account> acc = ([SELECT Id FROM Account WHERE Name = :accountName]);
        
        System.debug(acc);

		// if the Account exists, update the description
        if(acc.size() > 0){
            for(Account eachAcc :acc){
                eachAcc.Description = 'Updated Account';
            update eachAcc;
            System.debug(eachAcc);
            return eachAcc;
            }
            
        }
       // otherwise, create a new Account and set the description
            Account newAcc = new Account();
            newAcc.Name = accountName;
            newAcc.Description = 'New Account';
           insert newAcc;
           return newAcc;
		// Upsert the Account
		
	}

    /**
     * Question 10
	 * Upserts accounts and links contacts to them based on the contact's last name and account name.
	 * Create or use existing account with contact last name. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
	 * Contacts are then linked to these accounts based on a full last name match.
     * Example Contact Last Name = Doe Link to Account Name = Doe 
     * Example Contact Last Name = Jane Link to Account Name = Jane
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
        List<Contact> upsertList = new List<Contact>();
		// Loop through each Contact
        for(Contact eachContact :contactsToUpsert){
            // Extract the Account Name from Contact's LastName
            String lastName = eachContact.LastName;
            System.debug(lastName);

            // Get the account based on the name or create one if it doesn't exist
            Account acc = upsertAccount(eachContact.LastName);
            System.debug(eachContact.Account);
            
            // Link the Contact to its Account using the Account Id
            eachContact.AccountId = acc.Id;
            upsertList.add(eachContact);
            System.debug(upsertList);
        }
		// Upsert the Contacts
        upsert upsertList;
	}

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        List<Lead> leadList = new List<Lead>();
        // Loop through each Lead name
        for(String eachLead : leadNames){
            Lead newLead = new Lead();
                newLead.LastName = eachLead;
                newLead.Company = 'Test Lead';
            leadList.add(newLead);    
        }
        // Insert the Leads
        insert leadList;

        // Delete the Leads
        delete leadList;
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        // Insert the cases
        List<Case> caseList = new List<Case>();
        for(Integer i; i < numOfCases; i++){
            Case newCase = new Case();
            newCase.AccountId = accountId;
            newCase.Status = 'New';
            newCase.Origin = 'Web';
            newCase.Subject = 'Apex Created Case';
            newCase.Description = 'I Created This Case Via Apex!';
            caseList.add(newCase);
        }
        insert caseList;

        // Delete the cases
        delete caseList;
    }
}