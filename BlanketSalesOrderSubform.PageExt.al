pageextension 50141 BlanketSalesOrderSubform extends "Blanket Sales Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Qty. Paid For";Rec."Qty. Paid For")
            {
                ApplicationArea = All;
            }
            field("Qty. Remaining";Rec."Qty. Remaining")
            {
                ApplicationArea = All;
                Caption = 'Qty. to Load';
            }
            field("Statutory Qty. to Quote";Rec."Statutory Qty. to Quote")
            {
                ApplicationArea = All;
            }
            field("Qty. To Transfer";Rec."Qty. To Transfer")
            {
                ApplicationArea = All;
            }
            field("Qty. On Sales Order";Rec."Qty. On Sales Order")
            {
                ApplicationArea = All;
            }
            field("Transfered Qty.";Rec."Transfered Qty.")
            {
                ApplicationArea = All;
            }
        }
    }
}
