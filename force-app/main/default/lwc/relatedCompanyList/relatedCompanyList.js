import { LightningElement, track, api } from 'lwc';

export default class RelatedCompanyList extends LightningElement {
    @api recordId;
    @track companyColumns = [
        { label: 'NAME', fieldName: 'LinkName', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_top' } },
        { label: 'Responsibility centre Code', fieldName: 'Responsibility_centre_Code__c', type: 'text' },
        { label: 'Responsibility centre Name', fieldName: 'Responsibility_centre_Name__c', type: 'text' },
        { label: 'State Code', fieldName: 'State_Code__c', type: 'text' }
    ]
    connectedCallback(){
        console.log('account Record Id '+ this.recordId);
    }
}