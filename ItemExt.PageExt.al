pageextension 50204 ItemExt extends "Item Card"
{
    layout
    {
        addafter(Inventory)
        {
            field("Product to load";Rec."Product to load")
            {
                ToolTip = 'Specifies the value of the Product to load field.';
                ApplicationArea = All;
            }
        }
    }
}
