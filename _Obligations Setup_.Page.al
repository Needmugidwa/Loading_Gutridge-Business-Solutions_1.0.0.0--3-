page 50143 "Obligations Setup"
{
    ApplicationArea = All;
    Caption = 'Obligations Setup';
    PageType = List;
    SourceTable = "Statutory Obligations Setup";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Active;Rec.Active)
                {
                    ToolTip = 'Specifies the value of the Active field.';
                    ApplicationArea = All;
                }
                field("Charge Type";Rec."Charge Type")
                {
                    ToolTip = 'Specifies the value of the Charge Type field.';
                    ApplicationArea = All;
                }
                field("Code";Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field("Creation Date";Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date field.';
                    ApplicationArea = All;
                }
                field("Currency Code";Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.';
                    ApplicationArea = All;
                }
                field("Date Last Modified";Rec."Date Last Modified")
                {
                    ToolTip = 'Specifies the value of the Date Last Modified field.';
                    ApplicationArea = All;
                }
                field("End Date";Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
                field("G/L Account Name";Rec."G/L Account Name")
                {
                    ToolTip = 'Specifies the value of the G/L Account Name field.';
                    ApplicationArea = All;
                }
                field("G/L Account No.";Rec."G/L Account No.")
                {
                    ToolTip = 'Specifies the value of the G/L Account No. field.';
                    ApplicationArea = All;
                }
                field("Modified By";Rec."Modified By")
                {
                    ToolTip = 'Specifies the value of the Modified By field.';
                    ApplicationArea = All;
                }
                field("No. Series";Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.';
                    ApplicationArea = All;
                }
                field("Product Code";Rec."Product Code")
                {
                    ToolTip = 'Specifies the value of the Product Code field.';
                    ApplicationArea = All;
                }
                field("Product Description";Rec."Product Description")
                {
                    ToolTip = 'Specifies the value of the Product Description field.';
                    ApplicationArea = All;
                }
                field("Start Date";Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt;Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy;Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                    ApplicationArea = All;
                }
                field(SystemId;Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt;Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy;Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                    ApplicationArea = All;
                }
                field("Unit Price";Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
