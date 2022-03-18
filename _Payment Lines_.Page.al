page 50146 "Payment Lines"
{
    Caption = 'Payment Lines';
    PageType = ListPart;
    SourceTable = "Payment Line";

    // ApplicationArea = All;
    // UsageCategory = one;
    // Editable = 
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Line Type";Rec."Line Type")
                {
                    ToolTip = 'Specifies the value of the Line Type field.';
                    ApplicationArea = All;
                }
                field("No.";Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(Description;Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                    Editable = Rec."Line Type" = Rec."Line Type"::Payment;
                }
                field("Unit Price";Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field.';
                    ApplicationArea = All;
                }
                field("Line Amount";Rec."Line Amount")
                {
                    ToolTip = 'Specifies the value of the Line Amount field.';
                    ApplicationArea = All;
                }
                field("Line Amount LCY";Rec."Line Amount LCY")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
