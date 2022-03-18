pageextension 50145 SalesSetupExt extends "Sales & Receivables Setup"
{
    layout
    {
        addafter(General)
        {
            group(Loading)
            {
                field("Bank on Quotes(Foreign)";Rec."Bank on Quotes(Foreign)")
                {
                    ToolTip = 'Specifies the value of the Bank on Quotes(Foreign) field.';
                    ApplicationArea = All;
                }
                field("Bank on Quotes(Local)";Rec."Bank on Quotes(Local)")
                {
                    ToolTip = 'Specifies the value of the Bank on Quotes(Local) field.';
                    ApplicationArea = All;
                }
                field("Del. Note ID";Rec."Del. Note ID")
                {
                    ToolTip = 'Specifies the value of the Del. Note ID field.';
                    ApplicationArea = All;
                }
                field("Diesel Consignment Item";Rec."Diesel Consignment Item")
                {
                    ToolTip = 'Specifies the value of the Diesel Consignment Item field.';
                    ApplicationArea = All;
                }
                field("Ethanol Consignment Item";Rec."Ethanol Consignment Item")
                {
                    ToolTip = 'Specifies the value of the Ethanol Consignment Item field.';
                    ApplicationArea = All;
                }
                field("JetA1 Consignment Item";Rec."JetA1 Consignment Item")
                {
                    ToolTip = 'Specifies the value of the JetA1 Consignment Item field.';
                    ApplicationArea = All;
                }
                field("Job Q. Prio. for Post & Print";Rec."Job Q. Prio. for Post & Print")
                {
                    ToolTip = 'Specifies the value of the Job Q. Prio. for Post & Print field.';
                    ApplicationArea = All;
                }
                field("Job Queue Priority for Post";Rec."Job Queue Priority for Post")
                {
                    ToolTip = 'Specifies the value of the Job Queue Priority for Post field.';
                    ApplicationArea = All;
                }
                field("Max Remaining Qty (Orders)";Rec."Max Remaining Qty (Orders)")
                {
                    ToolTip = 'Specifies the value of the Max Remaining Qty for Archiving on Sales Orders field.';
                    ApplicationArea = All;
                }
                field("Max Remaining Qty(Glob.Orders)";Rec."Max Remaining Qty(Glob.Orders)")
                {
                    ToolTip = 'Specifies the value of the Max Remaining Qty for Archiving on Blanket Orders field.';
                    ApplicationArea = All;
                }
                field("Paraffin Item";Rec."Paraffin Item")
                {
                    ToolTip = 'Specifies the value of the Paraffin Item field.';
                    ApplicationArea = All;
                }
                field("Petrol Consignment Item";Rec."Petrol Consignment Item")
                {
                    ToolTip = 'Specifies the value of the Petrol Consignment Item field.';
                    ApplicationArea = All;
                }
                field("Picking Slip ID";Rec."Picking Slip ID")
                {
                    ToolTip = 'Specifies the value of the Picking Slip ID field.';
                    ApplicationArea = All;
                }
                field("Product Release Memo Mandatory";Rec."Product Release Memo Mandatory")
                {
                    ToolTip = 'Specifies the value of the Product Release Memo Mandatory field.';
                    ApplicationArea = All;
                }
                field("Product Release Memo Nos.";Rec."Product Release Memo Nos.")
                {
                    ToolTip = 'Specifies the value of the Product Release Memo Nos. field.';
                    ApplicationArea = All;
                }
                field("Proforma Invoice ID";Rec."Proforma Invoice ID")
                {
                    ToolTip = 'Specifies the value of the Proforma Invoice ID field.';
                    ApplicationArea = All;
                }
                field("Release Memo Email Subject";Rec."Release Memo Email Subject")
                {
                    ToolTip = 'Specifies the value of the Release Memo Email Subject field.';
                    ApplicationArea = All;
                }
                field("ReleaseMemo Default Email Body";Rec."ReleaseMemo Default Email Body")
                {
                    ToolTip = 'Specifies the value of the Release Memo Default Email Body field.';
                    ApplicationArea = All;
                }
                field("Road Tanker Max Qty to Load";Rec."Road Tanker Max Qty to Load")
                {
                    ToolTip = 'Specifies the value of the Road Tanker Max Qty to Load field.';
                    ApplicationArea = All;
                }
                field("S-Order ID";Rec."S-Order ID")
                {
                    ToolTip = 'Specifies the value of the S-Order ID field.';
                    ApplicationArea = All;
                }
                field("Statutory Obligation Nos.";Rec."Statutory Obligation Nos.")
                {
                    ApplicationArea = All;
                }
                field("Payment Nos";Rec."Payment Nos")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
