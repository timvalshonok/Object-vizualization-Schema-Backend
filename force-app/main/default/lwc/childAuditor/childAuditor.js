// import { LightningElement, wire, api } from 'lwc';
// import { refreshApex } from '@salesforce/apex';
// import { getObjectInfo } from 'lightning/uiObjectInfoApi';
// import getChildRelation from '@salesforce/apex/ChildObjectsController.getChildRelation';

// export default class ChildAuditor extends LightningElement {

//     objectName;
//     recordId;
//     childObjects;

//     connectedCallback(){
//         [this.objectName, this.recordId] = window.location.pathname.split('/').slice(3,5);
//     }

//     @wire(getObjectInfo, { objectApiName: '$objectName' })
//     objectInfo(result) {
//         if(result.data) {
//             this.showChildObjects(result.data.childRelationships);
//             // this.objectInfo = data;
//             // console.log(data);
//             // this.searchProperties = this.objectInfo?.childRelationships.map( row => {
//             //     return ({childObjectApiName: row.childObjectApiName, fieldName: row.fieldName})
//             // });
//             // console.log(this.searchProperties);
//         } else if(result.error) {
//             console.log(error);
//         }
//     }

//     showChildObjects(data) {
//         let childRelationships = {};
//         data.forEach((child) => {
//             childRelationships[child.childObjectName] = child.fieldName;
//         })
//         getChildRelation({childRelationships: childRelationships, recordId: this.recordId})
//         .then((result) => {
//             let childObjects = [];
//             Object.keys(result).forEach((key) => {
//                 childObjects.push({key: key, value: result[key]});
//             })
//             this.childObjects = childObjects;
//         })
//         .catch((error) => {
//             console.log(error);
//         })
//     }

//     // refreshComponent(event){
//     //     return refreshApex(this.childRecords);
//     // }
    
//     // @wire(getAccountChildRecords,{accountId: '$accountId'})
//     // wiredResult(value) {
//     //     this.accountChildRecords = value;
//     //     const {data,error} = value;
//     //     if (data) {
//     //         console.log(data);
//     //         this.accountRecordsCount = Object.keys(data[0]).map(key => {
//     //             return key !='Id' ? {name: key, length: data[0][key].length} : ''});
//     //         console.log(this.childRecordsCount);
//     //     } else if (error) {
//     //         console.log(error);
//     //     }
//     // }
// }

import { LightningElement, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { refreshApex } from '@salesforce/apex';
import getRelatedChilds from '@salesforce/apex/ChildObjectsController.getRelatedChilds';

 export default class ChildAuditor extends LightningElement {

    objectName;
    recordId;
    childObjects;
    objectResponse;

    connectedCallback(){
        [this.objectName, this.recordId] = window.location.pathname.split('/').slice(3,5);
    }

    @wire(getObjectInfo, {objectApiName: '$objectName'}) 
    objectInfo(result){
        this.objectResponse = result;
        if(result.data){
            this.showChildObjects(result.data.childRelationships);
        }
        if(result.error){
            console.log(result.error);
        } 
    }

    showChildObjects(data){
        let childRelationships = {};
        data.forEach((child) => {
            childRelationships[child.childObjectApiName] = child.fieldName;
        })
        getRelatedChilds({childRelationships: childRelationships, recordId: this.recordId})
        .then((result) => {
            let childObjects = [];
            Object.keys(result).forEach((key) => {
                childObjects.push({row: key, value: result[key]});
            })
            this.childObjects = childObjects;
        })
        .catch((error) => {
            console.log(error);
        })
    }

    refreshComponent(){
        refreshApex(this.objectResponse);
    }
}