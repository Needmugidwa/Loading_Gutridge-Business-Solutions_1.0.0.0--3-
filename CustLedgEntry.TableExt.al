tableextension 50146 CustLedgEntry extends "Cust. Ledger Entry"
{
    fields
    {
        field(50000;"Sales Order No.";Code[20])
        {
        }
        field(50001;"Staff Payments";Boolean)
        {
        }
        field(50002;"Payment Type";Option)
        {
            Caption = 'Payment Type';
            OptionCaption = ',Cash,Cheque,RTGS,Direct Deposit';
            OptionMembers = , Cash, Cheque, RTGS, "Direct Deposit";
        }
        field(50003;"Sales Invoice No.";Code[20])
        {
        }
        field(50004;Exported;Boolean)
        {
        }
    }
}
