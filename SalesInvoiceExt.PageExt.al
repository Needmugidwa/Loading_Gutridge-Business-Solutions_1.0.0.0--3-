pageextension 50146 SalesInvoiceExt extends "Sales Invoice"
{
    layout
    {
        addafter(Status)
        {
            group(ServiceCharges)
            {
                Caption = 'Service Charges';

                field("All Service Charges";Rec."All Service Charges")
                {
                    ApplicationArea = All;
                }
                field("Pipeline Local Fee Charges";Rec."Pipeline Local Fee Charges")
                {
                    ApplicationArea = All;
                }
                field("Pipeline Foreign Fee Charges";Rec."Pipeline Foreign Fee Charges")
                {
                    ApplicationArea = All;
                }
                field("Zinara Charges";Rec."Zinara Charges")
                {
                    ApplicationArea = All;
                }
                field("Duty Charges";Rec."Duty Charges")
                {
                    ApplicationArea = All;
                }
                field("Storage and Handling - Local";Rec."Storage and Handling - Local")
                {
                    ApplicationArea = All;
                }
                field("Storage and Handling - Foreign";Rec."Storage and Handling - Foreign")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
