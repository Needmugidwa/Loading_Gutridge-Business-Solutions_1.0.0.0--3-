page 50100 "Transfer-to"
{
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            field(TransfertoCustomerNo;TransfertoCustomerNo)
            {
                ApplicationArea = All;
                // Editable = false;
                Caption = 'Transfer-to Customer No.';
                TableRelation = Customer;
            }
        }
    }
    procedure Initialize()begin
        TransfertoCustomerNo:='';
    end;
    procedure GetDetails(Var TransfertoCustomerNo1: Code[20])begin
        TransfertoCustomerNo1:=TransfertoCustomerNo;
    end;
    var TransfertoCustomerNo: Code[20];
}
