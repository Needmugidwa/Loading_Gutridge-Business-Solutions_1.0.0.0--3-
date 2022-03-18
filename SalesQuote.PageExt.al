pageextension 50148 SalesQuote extends "Sales Quote"
{
    layout
    {
        addlast(General)
        {
            field("Blanket Order No.";Rec."Blanket Order No.")
            {
                ApplicationArea = All;
            }
            field("Payment Receipt No.";Rec."Payment Receipt No.")
            {
                ApplicationArea = All;
            }
            group(ServiceCharges)
            {
                Caption = 'Service Charges';

                // Visible = false;
                field("All Service Charges";Rec."All Service Charges")
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
                field("Pipeline Local Fee Charges";Rec."Pipeline Local Fee Charges")
                {
                    ToolTip = 'Specifies the value of the Pipeline Local Fee Charges field.';
                    ApplicationArea = All;
                }
                field("Pipeline Foreign Fee Charges";Rec."Pipeline Foreign Fee Charges")
                {
                    ToolTip = 'Specifies the value of the Pipeline Foreign Fee Charges field.';
                    ApplicationArea = All;
                }
                field("Storage and Handling - Local";Rec."Storage and Handling - Local")
                {
                    ToolTip = 'Specifies the value of the Storage and Handling - Local field.';
                    ApplicationArea = All;
                }
                field("Storage and Handling - Foreign";Rec."Storage and Handling - Foreign")
                {
                    ToolTip = 'Specifies the value of the Storage and Handling - Foreign field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        modify(Reopen)
        {
            trigger OnAfterAction()begin
                Rec.TestField("Blanket Order No.", '');
            end;
        }
        addafter(MakeOrder)
        {
            action(AddPayment)
            {
                ApplicationArea = All;
                Caption = 'Add &Payment';
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Add Partial/Full Payment For Customer';

                trigger OnAction()var ChangePMStatus: Page "Process Blanket Order";
                ActionType: Enum "Blanket Order Actions";
                CustomSalesFunctions: Codeunit "Custom Sales Functions";
                PaymentHeader: Record "Payment Header";
                begin
                    Rec.CalcFields("Payment Receipt No.");
                    if Rec."Payment Receipt No." = '' then CustomSalesFunctions.AddPayment(Rec)
                    else
                    begin
                        PaymentHeader.SetRange("Document Type", PaymentHeader."Document Type"::Payment);
                        PaymentHeader.SetRange("Receipt No.", Rec."Payment Receipt No.");
                        if PaymentHeader.FindFirst()then if PaymentHeader.Closed then begin
                                if Confirm('The Payment Receipt has been closed do you want to view the receipt', false)then Page.Run(Page::"Payment Header", PaymentHeader)end
                            else
                                Page.Run(Page::"Payment Header", PaymentHeader);
                    end;
                end;
            }
            action(CreateSalesInv)
            {
                ApplicationArea = All;
                Caption = 'Create &Invoice';
                Image = Quote;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Create Statutory Invoice  For Customer.';
                Visible = false;

                trigger OnAction()var ChangePMStatus: Page "Process Blanket Order";
                ActionType: Enum "Blanket Order Actions";
                CustomSalesFunctions: Codeunit "Custom Sales Functions";
                begin
                    CustomSalesFunctions.CreateSalesInvoice(Rec);
                end;
            }
        }
        modify(MakeInvoice)
        {
            Visible = false;
        }
    }
}
