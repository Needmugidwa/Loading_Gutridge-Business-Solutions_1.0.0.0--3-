tableextension 50141 SalesLine extends "Sales Line"
{
    fields
    {
        modify("No.")
        {
        TableRelation = if(Type=const(Statutory))Item."No.";
        }
        modify("Qty. to Ship")
        {
        trigger OnAfterValidate()begin
            if "Document Type" = "Document Type"::"Blanket Order" then begin
                Rec.CalcFields("Qty. On Sales Order");
                if Rec."Qty. to Ship" > Rec."Qty. Remaining" then Error('Quantity Exceeds Paid for quantities');
            end;
        end;
        }
        modify(Quantity)
        {
        trigger OnAfterValidate()begin
            if Rec."Document Type" = Rec."Document Type"::"Blanket Order" then Validate("Qty. to Ship", 0);
        end;
        }
        field(50000;"Receipt No.";Code[20])
        {
        }
        field(50001;"Batch No.";Code[20])
        {
        }
        field(50002;"Loading Order No.";Code[20])
        {
            TableRelation = "Loading Ticket";
        }
        field(50003;"Qty. Paid For";Decimal)
        {
            Editable = false;

            trigger OnValidate()begin
                if "Document Type" = "Document Type"::"Blanket Order" then begin
                    rec.CalcFields("Qty. On Sales Order");
                    Rec.Validate("Qty. Remaining", "Qty. Paid For" - "Qty. On Sales Order");
                end;
            end;
        }
        field(50004;"Qty. Remaining";Decimal)
        {
            Editable = false;
        }
        field(50005;"Qty. Remaining to Load";Decimal)
        {
        }
        field(50007;"Make Order Date";Date)
        {
        }
        field(50010;"Statutory Line";Boolean)
        {
            //Editable = false;
            trigger OnValidate()var Sline: Record "Sales Line";
            Item: Record Item;
            SalesHeader: Record "Sales Header";
            begin
                SalesHeader.Get(Rec."Document Type", Rec."Document No.");
                case Type of Type::Statutory: BEGIN
                    IF "Document Type" = "Document Type"::Invoice THEN IF(NOT SalesHeader."Zinara Charges") AND (NOT SalesHeader."Duty Charges") AND (NOT SalesHeader."Storage and Handling - Local") AND (NOT SalesHeader."Pipeline Local Fee Charges") AND (NOT SalesHeader."Storage and Handling - Foreign") AND (NOT SalesHeader."Pipeline Foreign Fee Charges")THEN ERROR('You must select at least one Statutory charge on Sales Header.');
                    GetSalesHeader;
                    Sline.RESET;
                    Sline.SETRANGE("Document Type", "Document Type");
                    Sline.SETRANGE("Document No.", SalesHeader."No.");
                    Sline.SETRANGE("No.", "No.");
                    IF Sline.FINDFIRST THEN ERROR('Item No. %1 already exist on Line No. %2.', "No.", Sline."Line No.");
                    Item.GET("No.");
                    Item.TESTFIELD(Description);
                    "Posting Group":=Item."Inventory Posting Group";
                    "Gen. Prod. Posting Group":=Item."Gen. Prod. Posting Group";
                    "VAT Prod. Posting Group":=Item."VAT Prod. Posting Group";
                    Description:=Item.Description;
                    "Statutory Item No.":=Item."No.";
                    "Is Statutory Line":=TRUE;
                    SalesHeader."Has Statutory Balance":=TRUE;
                    SalesHeader.MODIFY;
                END;
                //<< LAW18.00
                END;
                //>>LAW18.00
                IF(Type <> Type::Statutory) AND (NOT "Statutory Line")THEN BEGIN
                    SalesHeader."Has Statutory Balance":=FALSE;
                // SalesHeader.MODIFY;
                END;
            //<<LAW18.00
            end;
        }
        field(50011;"Statutory Item No.";Code[20])
        {
            Editable = false;
            TableRelation = Item;
        }
        field(50012;"Order Date";Date)
        {
            Caption = 'Order Date';
            Editable = false;
        }
        field(50013;"Fiscal VAT G/L";Boolean)
        {
            CalcFormula = Lookup("G/L Account"."Fiscal VAT" WHERE("No."=FIELD("No.")));
            FieldClass = FlowField;
        }
        field(50014;"Customer Posting Group";Code[20])
        {
            CalcFormula = Lookup(Customer."Customer Posting Group" WHERE("No."=FIELD("Sell-to Customer No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50018;"Require Loading Authority";Boolean)
        {
            Description = 'LAW18.00';
            Editable = false;
        }
        field(50019;"Is Statutory Line";Boolean)
        {
            Description = 'LAW18.00';
        }
        field(50020;"Statutory Balance";Decimal)
        {
            Description = 'LAW18.00';
            Editable = false;
        }
        field(50021;"Statutory Qty on Order";Decimal)
        {
            Description = 'LAW18.00';
            Editable = false;
        }
        field(50022;"Has Updated Qty on Order";Boolean)
        {
            Description = 'LAW18.00';
        }
        field(50023;"Statutory Remaining Qty";Decimal)
        {
            Description = 'LAW18.00';
        }
        field(50024;"Statutory Invoice No.";Code[20])
        {
            Description = 'LAW18.00';
            Editable = false;

            trigger OnLookup()var PostedInvoice: Record "Sales Invoice Header";
            begin
            end;
            trigger OnValidate()var PostedInvoice: Record "Sales Invoice Header";
            begin
            end;
        }
        field(50025;"Does not require Statutory Inv";Boolean)
        {
            Description = 'LAW19.00';
        }
        field(50026;"Release Memo No.";Code[20])
        {
            Description = 'LAW20.00';
            Editable = false;
        }
        field(50027;"Is Handled";Boolean)
        {
            Description = 'LAW20.00';
        }
        field(50099;Exported;Boolean)
        {
            Description = 'Mirroring';
        }
        field(50100;"IsHandled Delete";Boolean)
        {
            Description = 'OverideArchive';
        }
        field(50101;"Amount (LCY)";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50102;"Amount Including VAT (LCY)";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT (LCY)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50104;"Statutory Qty. to Quote";Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()begin
                Rec.CalcFields("Transfered Qty.");
                if((Rec.Quantity - Rec."Transfered Qty." - Rec."Qty. Paid For") < Rec."Statutory Qty. to Quote")then Error('Quantity to quote must not exceed the available qty');
            end;
        }
        field(50106;"Qty. to Load";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50107;"Qty. On Sales Order";Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Outstanding Quantity" where("Blanket Order No."=field("Document No."), "Document Type"=filter(Order), "No."=field("No.")));
            Editable = false;
        }
        field(50109;"Qty. To Transfer";Decimal)
        {
            // Editable = false;
            trigger OnValidate()begin
                if "Document Type" = "Document Type"::"Blanket Order" then begin
                    rec.CalcFields("Transfered Qty.");
                    If((Rec.Quantity - Rec."Transfered Qty." - Rec."Qty. Paid For") < Rec."Qty. To Transfer")then Error('Quantities Have Been Exceeded');
                end;
            end;
        }
        field(50222;"Transfered Qty.";Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line".Quantity where("Document Type"=const("Blanket Order"), "Blanket Order No."=field("Document No.")));
            Editable = false;
        }
    }
    var SalesHder: Record "Sales Header";
    SalesHdr2: Record "Sales Header";
    local procedure CheckIfReleaseMemoIsBlank(SHeader: Record "Sales Header")var SalesSetup: Record "Sales & Receivables Setup";
    ProductReleaseMemo: Record "Product Release Memo Header";
    begin
        // IF (SHeader."Product Release Memo No." <> '') AND (SHeader.Status <> SHeader.Status::Released) THEN
        //  ERROR('Product Release Memo No. must be blank in Sales Order No. %1.', SHeader."No.");
        if ProductReleaseMemo.GET(ProductReleaseMemo."Document Type"::"Product Release Memo", SHeader."Product Release Memo No.")then ProductReleaseMemo.TESTFIELD("Approval Status", ProductReleaseMemo."Approval Status"::Open);
    end;
    trigger OnAfterInsert()var SalesHeader: Record "Sales Header";
    begin
        case Rec."Document Type" of Rec."Document Type"::"Blanket Order": begin
            SalesHeader.get(SalesHeader."Document Type"::"Blanket Order", Rec."Document No.");
            // SalesHeader.TestField("HQ Sup. Ref");
            SalesHeader.TestField("Location Code");
        end;
        end;
    end;
    procedure BlanketOrderHasQtyToQuote(BlanketOrderNo: Code[20]): Boolean var BlanketSalesOrderLine: Record "Sales Line";
    begin
        BlanketSalesOrderLine.SetRange("Document Type", BlanketSalesOrderLine."Document Type"::"Blanket Order");
        BlanketSalesOrderLine.SetRange("Document No.", BlanketOrderNo);
        BlanketSalesOrderLine.SetFilter("Statutory Qty. to Quote", '<>%1', 0);
        if not BlanketSalesOrderLine.IsEmpty then exit(true);
        exit(false);
    end;
    procedure BlanketOrderHasQtyToTransfer(BlanketOrderNo: Code[20]): Boolean var BlanketSalesOrderLine: Record "Sales Line";
    begin
        BlanketSalesOrderLine.SetRange("Document Type", BlanketSalesOrderLine."Document Type"::"Blanket Order");
        BlanketSalesOrderLine.SetRange("Document No.", BlanketOrderNo);
        BlanketSalesOrderLine.SetFilter("Qty. To Transfer", '<>%1', 0);
        if not BlanketSalesOrderLine.IsEmpty then exit(true);
        exit(false);
    end;
}
