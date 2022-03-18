table 50249 "Pick Instruction Line"
{
    fields
    {
        field(2;"Document No.";Code[20])
        {
            TableRelation = "Pick Instruction Header"."No.";
            DataClassification = ToBeClassified;
        }
        field(3;"Line No.";Integer)
        {
        }
        field(7;"Order No.";Code[20])
        {
            TableRelation = "Sales Header"."No." WHERE("Document Type"=FILTER(Order), "Sell-to Customer No."=field("Customer No."));
            DataClassification = ToBeClassified;
        }
        field(12;"Qty. Loaded - Ambient";Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Qty. Loaded (Ambient)';

            trigger OnValidate()begin
                // HasExceeded(Rec."Document No.");
                Rec.TestField("Order No.");
            end;
        }
        field(13;"Qty. Loaded - @ 20";Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Qty. Loaded (20 Degrees)';

            trigger OnValidate()begin
                // HasExceeded(Rec."Document No.");
                Rec.TestField("Order No.");
            end;
        }
        field(15;"Customer No.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
            Editable = false;
        }
        field(17;"Qty To Load";Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1;"Document No.", "Customer No.", "Line No.")
        {
        }
    }
    fieldgroups
    {
    }
    trigger OnDelete()var SHeader: Record "Sales Header";
    LALine: Record "Product Release Memo Line";
    begin
    end;
    trigger OnInsert()begin
    end;
    trigger OnModify()begin
    // LoadingAuthorityHeader.Get("Document Type", "Document No.");
    // LoadingAuthorityHeader.TestField("Approval Status", LoadingAuthorityHeader."Approval Status"::Open);
    end;
    var Item: Record Item;
    SalesHeader: Record "Sales Header";
    LoadingAuthorityLine: Record "Product Release Memo Line";
    LoadingAuthorityHeader: Record "Product Release Memo Header";
    CustLedgEntries: Page "Customer Ledger Entries";
    Custledg: Record "Cust. Ledger Entry";
    SalesInvoices: Page "Posted Sales Invoices";
    SalesHeaderInvoice: Record "Sales Invoice Header";
    SalesOrderPage: Page "Sales Order";
    ReleaseMemoHeader: Record "Product Release Memo Header";
    ReleaseMemoLine: Record "Product Release Memo Line";
    /// <summary>
 
/// HasExceeded. 
 
/// </summary>
 
/// <param name="PickNo">code[20].</param>
 procedure HasExceeded(PickNo: code[20])var PickInstruction: Record "Pick Instruction Header";
    begin
        PickInstruction.SetRange("No.", PickNo);
        if PickInstruction.FindFirst()then begin
            PickInstruction.TestField("Total Qty to Load");
            PickInstruction.CalcFields("Total Loaded Quantity");
            if(PickInstruction."Total Qty to Load" - PickInstruction."Total Loaded Quantity") < 0 then Error('Qty. Exceeded');
        end;
    end;
}
