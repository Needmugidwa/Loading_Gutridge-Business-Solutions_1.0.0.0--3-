pageextension 50147 SalesOrderSubform extends "Sales Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Statutory Line";Rec."Statutory Line")
            {
                ApplicationArea = All;
            }
            field("Blanket Order No";Rec."Blanket Order No.")
            {
                ApplicationArea = All;
            }
        }
        modify("Qty. to Ship")
        {
        Editable = false;
        }
    }
}
