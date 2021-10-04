import { LightningElement, wire } from 'lwc';
// import getAccountChildRecords from '@salesforce/apex/ChildObjectsController.getAccountChildRecords';
// import getContactChildRecords from '@salesforce/apex/ChildObjectsController.getContactChildRecords';
// import getContractChildRecords from '@salesforce/apex/ChildObjectsController.getContractChildRecords';
// import getOpportunityChildRecords from '@salesforce/apex/ChildObjectsController.getOpportunityChildRecords';
// import getCaseChildRecords from '@salesforce/apex/ChildObjectsController.getCaseChildRecords';
import { refreshApex } from '@salesforce/apex';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import getChildRelationships from '@salesforce/apex/ChildObjectsController.getChildRelationships';

export default class ChildAuditor extends LightningElement {

    objectName;
    recordId;

    accountChildRecords;
    contactChildRecords;
    accountRecordsCount;
    contactRecordsCount;
    
    accountId;
    contactId;
    contractId;
    opportunityId;
    caseId;

    objectInfo;
    searchProperties;

    connectedCallback(){
        [this.objectName, this.recordId] = window.location.pathname.split('/').slice(3,5);

        // let objectName = this.objectName;
        // if(objectName === 'Account') {
        //     this.accountId = this.recordId;
        // } else if(objectName === 'Contact') {
        //     this.contactId = this.recordId;
        // } else if(objectName === 'Contract') {
        //     this.contractId = this.recordId;
        // } else if(objectName === 'Opportunity') {
        //     this.opportunityId = this.recordId;
        // } else if(objectName === 'Case') {
        //     this.caseId = this.recordId;
        // }
    }

    // @wire(getAccountChildRecords,{accountId: '$accountId'})
    // wiredResult(value) {
    //     this.accountChildRecords = value;
    //     const {data,error} = value;
    //     if (data) {
    //         console.log(data);
    //         this.accountRecordsCount = Object.keys(data[0]).map(key => {
    //             return key !='Id' ? {name: key, length: data[0][key].length} : ''});
    //         console.log(this.childRecordsCount);
    //     } else if (error) {
    //         console.log(error);
    //     }
    // }

    @wire(getObjectInfo, { objectApiName: '$objectName' })
    objectInfo({data,error}) {
        if(data) {
            this.objectInfo = data;
            this.searchProperties = this.objectInfo?.childRelationships.map( row => {
                return ({childObjectApiName: row.childObjectApiName, fieldName: row.fieldName})
            });
            console.log(this.searchProperties);
        } else if(error) {
            console.log(error);
        }
    }

    @wire(getChildRelationships, { recordId: '$recordId', objectName: "$objectName" })
    wiredResults({data,error}){
        if(data) {
            console.log(data);
        } else if(error) {
            console.log(error);
        }
    }
    
    // @wire(getContactChildRecords,{contactId: '$contactId'})
    // wiredResult(value) {
    //     this.contactChildRecords = value;
    //     const {data,error} = value;
    //     if (data) {
    //         console.log(data);
    //         this.contactRecordsCount = Object.keys(data[0]).map(key => {
    //             return key !='Id' ? {name: key, length: data[0][key].length} : ''});
    //         console.log(this.contactRecordsCount)
    //     } else if (error) {
    //         console.log(error);
    //     }
    // }

    // @wire(getContractChildRecords,{contractId: '$contractId'})
    // wiredResult(value) {
    //     this.childRecords = value;
    //     const {data,error} = value;
    //     if (data) {
    //         console.log(data);
    //         this.childRecordsCount = Object.keys(data[0]).map(key => {
    //             return key !='Id' ? {name: key, length: data[0][key].length} : ''});
    //         console.log(this.childRecordsCount)
    //     } else if (error) {
    //         console.log(error);
    //     }
    // }

    // @wire(getOpportunityChildRecords,{opportunityId: '$opportunityId'})
    // wiredResult(value) {
    //     this.childRecords = value;
    //     const {data,error} = value;
    //     if (data) {
    //         console.log(data);
    //         this.childRecordsCount = Object.keys(data[0]).map(key => {
    //             return key !='Id' ? {name: key, length: data[0][key].length} : ''});
    //         console.log(this.childRecordsCount)
    //     } else if (error) {
    //         console.log(error);
    //     }
    // }

    // @wire(getCaseChildRecords,{caseId: '$caseId'})
    // wiredResult(value) {
    //     this.childRecords = value;
    //     const {data,error} = value;
    //     if (data) {
    //         console.log(data);
    //         this.childRecordsCount = Object.keys(data[0]).map(key => {
    //             return key !='Id' ? {name: key, length: data[0][key].length} : ''});
    //         console.log(this.childRecordsCount)
    //     } else if (error) {
    //         console.log(error);
    //     }
    // }

    refreshComponent(event){
        return refreshApex(this.childRecords);
    }
}