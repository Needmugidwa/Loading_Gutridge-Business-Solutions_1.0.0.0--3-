tableextension 50153 TransferLine extends "Transfer Line"
{
    fields
    {
        field(50000;"Memo Ref. No.";Code[20])
        {
            Editable = false;
        }
        field(50001;"Batch No.";Code[20])
        {
        }
        field(50002;"Loading Order No.";Code[20])
        {
            TableRelation = "Loading Ticket";
        }
        field(50003;"HQ Reference";Code[20])
        {
            Editable = false;
        }
    }
}
