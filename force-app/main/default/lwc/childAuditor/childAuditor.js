import { LightningElement, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { refreshApex } from '@salesforce/apex';
import getChildrelationships from '@salesforce/apex/ChildObjectsController.getChildrelationships';

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
            console.log(result.data);
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
        console.log(childRelationships);
        getChildrelationships({childRelationships: childRelationships, recordId: this.recordId})
        .then((result) => {
            let childObjects = [];
            Object.keys(result).forEach((key) => {
                childObjects.push({field: key, value: result[key]});
            })
            this.childObjects = childObjects;
            console.log(this.childObjects);
        })
        .catch((error) => {
            console.log(error);
        })
    }

    refreshComponent(){
        refreshApex(this.objectResponse);
    }
}