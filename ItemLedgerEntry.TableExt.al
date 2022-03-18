tableextension 50144 ItemLedgerEntry extends "Item Ledger Entry"
{
    fields
    {
        field(50000;"GL Account";Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(50001;"Receipts Transport Mode";Option)
        {
            OptionCaption = ' ,CPMZ,PZL,Road,Rail,Msasa and Mabvuku,Ship';
            OptionMembers = " ", CPMZ, PZL, Road, Rail, "Msasa and Mabvuku", Ship;
        }
        field(50002;"Withdrawals Transport Mode";Option)
        {
            OptionCaption = ' ,Road,Rail,Export Road,Export Rail,Pipeline';
            OptionMembers = " ", Road, Rail, "Export Road", "Export Rail", Pipeline;
        }
        field(50005;"Stock Issue No.";Code[20])
        {
            Description = 'StockIssues';
        }
        field(50006;"Stock Issue Line No.";Integer)
        {
            Description = 'StockIssues';
        }
        field(50007;Exported;Boolean)
        {
        }
    }
}
