page 50105 "Pick Instruction Lines"
{
    Caption = 'Pick Instruction Lines';
    PageType = ListPart;
    AutoSplitKey = true;
    SourceTable = "Pick Instruction Line";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No.";Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                    ApplicationArea = All;
                }
                field("Line No.";Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Order No.";Rec."Order No.")
                {
                    ToolTip = 'Specifies the value of the Order No. field.';
                    ApplicationArea = All;
                }
                field("Qty To Load";Rec."Qty To Load")
                {
                    ApplicationArea = All;
                }
                field("Qty. to Load";Rec."Qty. Loaded - Ambient")
                {
                    ToolTip = 'Specifies the value of the Qty. to Load field.';
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        CurrPage.Update(true);
                        Rec.HasExceeded(Rec."Document No.");
                    end;
                }
                field("Customer No.";Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Qty. Loaded - @ 20";Rec."Qty. Loaded - @ 20")
                {
                    ToolTip = 'Specifies the value of the Qty. Loaded (20 Degrees) field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
