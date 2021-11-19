import { LightningElement, track, wire } from 'lwc';
import getAllObjects from '@salesforce/apex/ObjectsController.getAllObjects';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class ListObjects extends LightningElement {
    
    wiredObjects;
    @track objects;
    @track objectName;
    @track objectInfo;

    //in the code below we get all the objects and assign them id, name
    @wire(getAllObjects)
    wiredObjectsResult(result) {
        this.wiredObjects = result;
        const {data, error} = result;
        if (data) {
            this.objects = Object.keys(data).map(key => {return { Id: key, Name: data[key] }})
            .sort(function (a, b) { return a.Id.localeCompare(b.Id);
            });
        } else if (error) {
            this.error = error;
            this.objects = undefined;
        }
    }

    //select object and assign it value to the this.objectName
    selectObject() {
        let select = this.template.querySelector('select');
        this.objectName = select.value;
        console.log(select.value);
    }

    //get all information about object through the dynamic objectName
    @wire(getObjectInfo,{objectApiName: '$objectName'}) objectInfo;

    //select the needed properties of the object and assign them key, value
    get objectInformation() {
        console.log(this.objectInfo);
        let _transformation = JSON.stringify(
            this.objectInfo.data, 
            ['label', 'apiName', 'keyPrefix', 'accessible', 'queryable', 'custom', 'updatable'], 2);
        return _transformation ? 
        Object.keys(JSON.parse(_transformation)).map(key => {return {k: key, v: this.objectInfo.data[key]}}) : 'None';
    }

    //get object fields and assign them key(field) and values(field properties)
    get objectFields() {
        let _transformation = JSON.stringify(
            this.objectInfo.data.fields, null, 2);
        return _transformation ?
        Object.keys(JSON.parse(_transformation)).map(key => {return {
            key: key, datatype: this.objectInfo.data.fields[key].dataType, 
            length: this.objectInfo.data.fields[key].length, 
            scale: this.objectInfo.data.fields[key].scale}}
        ) : 'None';
    }
}

