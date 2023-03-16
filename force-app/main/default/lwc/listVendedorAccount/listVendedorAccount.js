import { LightningElement, track } from 'lwc';
import getVendedoresWithAccounts from '@salesforce/apex/VendedoresController.getVendedoresWithAccounts';
import modalSetVendedorPadraoConta from 'c/modalSetVendedorPadraoConta';
import {refreshApex} from '@salesforce/apex';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';


export default class ListVendedorAccount extends LightningElement {

    @track vendedores;
    @track error;

    connectedCallback(){
        this.handleLoadData();
    }
    
    async handleItemRemove(event){
        const id = event.detail.item.alternativeText;
        console.log("onChange Account>>> " + id)
        const inputs = [];
        inputs.push({
            name: 'recordId',
            type: 'String',
            value: id,
        });
        console.log("inputs>>> " + inputs);
        const result = await modalSetVendedorPadraoConta.open({
            size: 'small',
            description: 'Informar o novo Vendedor Padrão para a Conta.',
            header: 'Atenção',
            flowName: 'FlowInformarVendedorPadraoConta',
            inputVariables: inputs,
        });
        console.log(result); 
        if(result == "salved") {
            await notifyRecordUpdateAvailable([{ recordId: id }]);
            await refreshApex(this.handleLoadData());
            console.log("After call refresh");
        }                    
    }

    handleLoadData(){
        getVendedoresWithAccounts()
            .then(result => {
                console.log("begin1.vendedores>>>" + JSON.stringify(this.vendedores));
                this.error = undefined;
                this.vendedores = [];
                console.log("begin2.vendedores>>>" + JSON.stringify(this.vendedores));
                let m_gold = "https://cdn-icons-png.flaticon.com/512/179/179249.png";
                let m_silver = "https://cdn-icons-png.flaticon.com/512/179/179251.png";
                let m_bronze = "https://cdn-icons-png.flaticon.com/512/179/179250.png";
                for(let idx in result) {
                    let accs = [];
                    console.log("accs " + idx + ">>>" + result[idx].Accounts__r);
                    for(let jdx in result[idx].Accounts__r){
                        let a_src;
                        let qualis = result[idx].Accounts__r[jdx].QualificacaoCliente__c;
                        if(qualis == "Ouro"){
                            a_src = m_gold;
                        } else if(qualis == "Prata"){
                            a_src = m_silver;
                        } else {
                            a_src = m_bronze;
                        }
                        accs.push({
                            type: 'avatar',
                            label: result[idx].Accounts__r[jdx].Name,
                            src: a_src,
                            variant: 'circle',
                            isLink: true,
                            alternativeText: result[idx].Accounts__r[jdx].Id,
                        });
                    }
                    let icone;
                    if(result[idx].RecordType.Name == "Interno"){
                        icone = "standard:employee_organization";
                    } else {
                        icone = "standard:channel_program_members";
                    }
                    this.vendedores.push({
                        Id: result[idx].Id,
                        Name: result[idx].Name,
                        Tipo: result[idx].RecordType.Name,
                        Accs: accs,
                        icon: icone,
                    });
                }    
                console.log("end.vendedores>>>" + JSON.stringify(this.vendedores));    
            })  
            .catch(error => {
                this.vendedores = undefined;
                this.error = error;
            });     
    }

}