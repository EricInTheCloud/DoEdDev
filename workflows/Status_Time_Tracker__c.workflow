<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>DOED_Update_End_Date_Time_Display</fullName>
        <field>End_Date_Time_Display__c</field>
        <formula>End_Date_Time__c</formula>
        <name>DOED Update End Date Time Display</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>DOED Update End Date Time</fullName>
        <actions>
            <name>DOED_Update_End_Date_Time_Display</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Start_Date_Time__c  &lt;&gt;  End_Date_Time__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
