page 50211 "Transporter Driver"
{
    ApplicationArea = All;
    Caption = 'Transporter Driver';
    PageType = List;
    SourceTable = "Transporter Driver";
    UsageCategory = Lists;
    InsertAllowed = false;
    CardPageId = 50102;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code";Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = reTestExpired;
                }
                field("Full Name";Rec."Driver Full Name")
                {
                    ToolTip = 'Specifies the value of the Full Name field.';
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = reTestExpired;
                }
                field("National ID No.";Rec."National ID No.")
                {
                    ToolTip = 'Specifies the value of the National ID No. field.';
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = reTestExpired;
                }
                field("Transpoter Code";Rec."Transpoter Code")
                {
                    ToolTip = 'Specifies the value of the Transpoter Code field.';
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = reTestExpired;
                }
                field(InActive;Rec.Status)
                {
                    ToolTip = 'Specifies the value of the InActive field.';
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = reTestExpired;
                }
            }
        }
    }
    trigger OnAfterGetCurrRecord()begin
        // reTestExpired := false;
        if Rec."Re-Test Expiration Date" < Today then reTestExpired:=true
        else
            reTestExpired:=false;
    end;
    var reTestExpired: Boolean;
}
