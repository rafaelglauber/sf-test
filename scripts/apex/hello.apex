// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents
List<Account> sObjectList = new List<Account>();
Accounts accs = new Accounts(sObjectList);
try {
    accs.onApplyDefaults();    
} catch (Exception o) {
    System.debug(o.getMessage());
}
