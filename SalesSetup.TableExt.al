tableextension 50145 SalesSetup extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000;"Proforma Invoice ID";Code[20])
        {
        }
        field(50001;"S-Order ID";Code[20])
        {
        }
        field(50002;"Del. Note ID";Code[20])
        {
        }
        field(50003;"Picking Slip ID";Code[20])
        {
        }
        field(50004;"Bank on Quotes(Foreign)";Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(50005;"Bank on Quotes(Local)";Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(50006;"Road Tanker Max Qty to Load";Decimal)
        {
            Description = 'RoadTankerQty';
        }
        field(50007;"Product Release Memo Nos.";Code[10])
        {
            Description = 'LAW18.00';
            TableRelation = "No. Series";
        }
        field(50008;"Petrol Consignment Item";Code[20])
        {
            TableRelation = Item."No.";
        }
        field(50009;"Product Release Memo Mandatory";Boolean)
        {
        }
        field(50010;"Statutory Obligation Nos.";Code[10])
        {
            Description = 'StatutoryW19.00';
            TableRelation = "No. Series";
        }
        field(50011;"Paraffin Item";Code[20])
        {
            TableRelation = Item."No.";
        }
        field(50012;"Diesel Consignment Item";Code[20])
        {
            TableRelation = Item."No.";
        }
        field(50013;"JetA1 Consignment Item";Code[20])
        {
            TableRelation = Item."No.";
        }
        field(50014;"Ethanol Consignment Item";Code[20])
        {
            TableRelation = Item."No.";
        }
        field(50015;"Release Memo Email Subject";Text[50])
        {
            Description = 'LoadingW20.10';
        }
        field(50016;"ReleaseMemo Default Email Body";Text[250])
        {
            Caption = 'Release Memo Default Email Body';
            Description = 'LoadingW20.10';
        }
        field(50017;"Max Remaining Qty (Orders)";Decimal)
        {
            Caption = 'Max Remaining Qty for Archiving on Sales Orders';
            Description = 'ArchiveOveride';
        }
        field(50018;"Max Remaining Qty(Glob.Orders)";Decimal)
        {
            Caption = 'Max Remaining Qty for Archiving on Blanket Orders';
            Description = 'ArchiveOveride';
        }
        field(50019;"Payment Nos";Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
    }
}
