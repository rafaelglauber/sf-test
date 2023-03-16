global class ScheduleAddressForAccountProcessing implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        if (ConfigMetadata.isBuscaCepViaScheduledApex())
            AccountsService.setAddressForAllAccount();
    }

}