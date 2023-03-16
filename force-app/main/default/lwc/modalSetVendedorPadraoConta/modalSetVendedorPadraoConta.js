import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class ModalSetVendedorPadraoConta extends LightningModal {
    @api header;
    @api flowName;
    @api inputVariables = [];

    connectedCallback(){
        console.log("openModal completed");
    }
    
    handleStatusChange(event) {
        if (event.detail.status === 'FINISHED'){
            this.close('salved');
        }
    }    

    handleCancel() {
        this.close('cancel');
    }
}