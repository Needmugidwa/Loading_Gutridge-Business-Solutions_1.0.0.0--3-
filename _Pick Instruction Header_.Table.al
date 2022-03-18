table 50135 "Pick Instruction Header"
{
    // Caption = 'Product Release Memo Header';
    DrillDownPageID = 50106;
    LookupPageID = 50106;

    fields
    {
        field(2;"No.";Code[20])
        {
        // TableRelation = "Product Release Memo Header"."No.";
        }
        field(4;"Document Date";Date)
        {
            trigger OnValidate()begin
            // UserSetup.Get(UserId);
            //if not UserSetup."Allow Product Rel Memo Editing" then
            // TestField("Approval Status", "Approval Status"::Open);
            end;
        }
        field(5;"No. Series";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(6;"No. Printed";Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(7;"Source Type";Option)
        {
            Editable = false;
            OptionCaption = ' ,Sales Order,Transfer Order,All';
            OptionMembers = " ", "Sales Order", "Transfer Order", All;
        }
        field(9;"Approval Status";Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Released,Completed';
            OptionMembers = Open, "Pending Approval", Released, Completed;

            trigger OnValidate()var LALine: Record "Product Release Memo Line";
            SalesHeader: Record "Sales Header";
            ReleaseSalesDocument: Codeunit "Release Sales Document";
            begin
            //>>>this block of code will be removed in the future as it caters for the 1st release of release memo
            // LALine.Reset;
            // LALine.SetRange(LALine."Document Type", "Document Type");
            // LALine.SetRange("Document No.", "No.");
            // if LALine.FindFirst and (LALine.Count > 1) then
            //     repeat
            //         if Modify then;
            //         SalesHeader.Get(SalesHeader."Document Type"::Order, LALine."Order No.");
            //         case "Approval Status" of
            //             "Approval Status"::Open:
            //                 ReleaseSalesDocument.PerformManualReopen(SalesHeader);
            //             "Approval Status"::Released:
            //                 ReleaseSalesDocument.PerformManualRelease(SalesHeader);
            //         end;
            //     until LALine.Next = 0;
            // //<<this block of code will be removed in the future as it caters for the 1st release of release memo
            end;
        }
        // trigger OnValidate()
        // begin
        //     LAHeader.Reset;
        //     LAHeader.SetFilter(LAHeader."No.", '<>%1', "No.");
        //     LAHeader.SetRange(LAHeader."Document No.", "Document No.");
        //     if LAHeader.FindFirst then
        //         Error('Sales Order No. %1 has already been assigned to Product Release Memo No %2', "Document No.", LAHeader."No.");
        //     SHeader.Get(SHeader."Document Type"::Order, "Document No.");
        //     SHeader."Product Release Memo No." := "No.";
        //     SHeader.Modify;
        //     if (xRec."Document No." <> Rec."Document No.") and (xRec."Document No." <> '') then begin
        //         SHeader.Get(SHeader."Document Type"::Order, xRec."Document No.");
        //         SHeader.Validate("Product Release Memo No.", '');
        //         SHeader.Modify;
        //     end;
        // end;
        field(14;"Total Qty to Load";Decimal)
        {
        // Editable = false;
        // FieldClass = FlowField;
        }
        field(16;"Number of Orders";Integer)
        {
            CalcFormula = Count("Pick Instruction Line" WHERE("Document No."=FIELD("No.")));
            FieldClass = FlowField;
        }
        field(19;"Has Lines";Boolean)
        {
            // CalcFormula = Exist("Product Release Memo Line" WHERE("Document Type" = FIELD("Document Type"),
            //                                                        "Document No." = FIELD("No.")));
            CalcFormula = exist("Pick Instruction Line" WHERE("Document No."=FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005;"Item No.";Code[20])
        {
            // Editable = false;
            // FieldClass = FlowField;
            TableRelation = Item;
        }
        field(50006;"Outstanding Quantity";Decimal)
        {
            Editable = false;
        // FieldClass = FlowField;
        }
        field(50106;"Meter Code";Code[20])
        {
            TableRelation = "Meter Codes" WHERE("Location Code"=FIELD("Loading Location"));
        }
        field(50007;Loader;Code[50])
        {
            TableRelation = "Loading Personnel" WHERE("Location Code"=FIELD("Loading Location"));

            trigger OnValidate()begin
                Rec.TestField("Approval Status", Rec."Approval Status"::Released);
            end;
        }
        field(50008;Dipper;Code[50])
        {
            TableRelation = "Loading Personnel" WHERE("Location Code"=FIELD("Loading Location"));

            trigger OnValidate()begin
                Rec.TestField("Approval Status", Rec."Approval Status"::Released);
            end;
        }
        field(50009;Sealer;Code[50])
        {
            TableRelation = "Loading Personnel" WHERE("Location Code"=FIELD("Loading Location"));

            trigger OnValidate()begin
                Rec.TestField("Approval Status", Rec."Approval Status"::Released);
            end;
        }
        field(50010;"Transporter Name";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50011;"Horse Registration No.";Code[20])
        {
            Description = 'LoadingW20.10';
            TableRelation = "Truck Registration" WHERE(Type=CONST(Horse), Status=const(Enabled));
            ValidateTableRelation = false;

            trigger OnValidate()var TruckRegistration: Record "Truck Registration";
            begin
                Rec.TestField("Transport Mode", Rec."Transport Mode"::Road);
                if "Horse Registration No." = '' then exit;
                if TruckRegistration.GET("Horse Registration No.")then TruckRegistration.TESTFIELD(Type, TruckRegistration.Type::Horse)// else begin
            //     TruckRegistration.INIT;
            //     TruckRegistration."Registration No." := "Horse Registration No.";
            //     TruckRegistration.Type := TruckRegistration.Type::Horse;
            //     TruckRegistration.INSERT;
            // end;
            end;
        }
        field(50012;"Driver Name";Text[50])
        {
            Editable = false;

            trigger OnValidate()begin
            // Rec.TestField("Trans Mode", Rec."Trans Mode"::"Road Tanker");
            end;
        }
        field(50013;"Driver ID";Code[20])
        {
            trigger OnValidate()begin
            // Rec.TestField("Trans Mode", Rec."Trans Mode"::"Road Tanker");
            end;
        }
        field(50014;"Loading Location";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(50015;"Customer No.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(50017;"Customer Name";Text[100])
        {
            // DataClassification = ToBeClassified;
            TableRelation = Customer.Name;
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No."=field("Customer No.")));
            Editable = false;
        }
        field(50018;"Transporter Code";Code[20])
        {
            Description = 'LoadingW20.00';
            TableRelation = Transporter where(Status=const(Enabled));

            trigger OnValidate()var Transporter: Record Transporter;
            begin
                if Transporter.GET("Transporter Code")then "Transporter Name":=Transporter.Name
                else
                    "Transporter Name":='';
            end;
        }
        field(50019;"Driver Code";Code[20])
        {
            Description = 'LoadingW20.00';
            TableRelation = "Transporter Driver".Code WHERE("Transpoter Code"=FIELD("Transporter Code"), Status=const(Enabled), "National ID No."=FILTER(<>''));

            trigger OnValidate()var TransporterDriver: Record "Transporter Driver";
            begin
                TestField("Transporter Code");
                Rec.TestField("Transport Mode", Rec."Transport Mode"::Road);
                if TransporterDriver.GET("Driver Code", "Transporter Code")then begin
                    TransporterDriver.TESTFIELD("National ID No.");
                    "Driver Name":=TransporterDriver."Driver Full Name";
                    "Driver ID":=TransporterDriver."National ID No.";
                end
                else
                begin
                    "Driver Name":='';
                    "Driver ID":='';
                end;
            end;
        }
        field(50020;"Loading Authority No.";Code[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()var PickInstruction: Record "Pick Instruction Header";
            begin
                Rec.TestField("Customer No.");
                PickInstruction.SetRange("Customer No.", Rec."Customer No.");
                PickInstruction.SetRange("Loading Authority No.", Rec."Loading Authority No.");
                if not PickInstruction.IsEmpty then Error('Loading Authority No. already userd for this customer.');
            end;
        }
        field(50098;"Trailer Registration No.";Code[20])
        {
            Description = 'LoadingW20.10';
            TableRelation = "Truck Registration" WHERE(Type=CONST(Trailer), "Horse Id"=field("Horse Registration No."));
            ValidateTableRelation = false;

            trigger OnValidate()var TruckRegistration: Record "Truck Registration";
            begin
                Rec.TestField("Transport Mode", Rec."Transport Mode"::Road);
                if "Trailer Registration No." = '' then exit;
                if TruckRegistration.GET("Trailer Registration No.")then TruckRegistration.TESTFIELD(Type, TruckRegistration.Type::Trailer)// else begin
            //     TruckRegistration.INIT;
            //     TruckRegistration."Registration No." := "Trailer Registration No.";
            //     TruckRegistration.Type := TruckRegistration.Type::Trailer;
            //     TruckRegistration.INSERT;
            // end;
            end;
        }
        field(50100;"Total Loaded Quantity";Decimal)
        {
            // DataClassification = ToBeClassified;
            FieldClass = FlowField;
            CalcFormula = sum("Pick Instruction Line"."Qty. Loaded - Ambient" where("Document No."=field("No.")));
            Editable = false;
        }
        field(50102;"Sales Orders";Text[2048])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50103;"Transport Mode";Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = , Road, Rail;
        }
    }
    keys
    {
        key(Key1;"No.")
        {
        }
    }
    fieldgroups
    {
    }
    trigger OnDelete()var // ApprovalsMgt: Codeunit "Approvals Mgmt.";
    begin
        TestField("Approval Status", "Approval Status"::Open);
    // ApprovalsMgt.DeleteApprovalEntry(Rec);
    end;
    trigger OnInsert()begin
        SalesSetup.Get;
        if "No." = '' then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", 0D, "No.", "No. Series");
        end;
        "Document Date":=WorkDate;
        "Source Type":="Source Type"::"Sales Order";
    end;
    trigger OnModify()begin
        if Rec."Approval Status" = Rec."Approval Status"::Completed then;
    // Error('Cannot Modify completed pick instruction');
    end;
    var NoSeriesMgt: Codeunit NoSeriesManagement;
    SalesSetup: Record "Sales & Receivables Setup";
    UserSetup: Record "User Setup";
    CustLedgEntries: Page "Customer Ledger Entries";
    Custledg: Record "Cust. Ledger Entry";
    SalesHeader: Record "Sales Header";
    SalesInvoices: Page "Sales Invoice List";
    SalesHeaderInvoice: Record "Sales Header";
    LAHeader: Record "Product Release Memo Header";
    SHeader: Record "Sales Header";
    SalesList: Page "Sales Order List";
    SHeaderList: Record "Sales Header";
    Cust: Record Customer;
    procedure AssistEdit(OldLoadAuthHeader: Record "Pick Instruction Header"): Boolean var LoadingAuthHeader: Record "Pick Instruction Header";
    OldAuthHeader: Record "Pick Instruction Header";
    begin
        // with LoadingAuthHeader do begin
        LoadingAuthHeader.Copy(Rec);
        SalesSetup.Get;
        TestNoSeries;
        if NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldAuthHeader."No. Series", "No. Series")then begin
            NoSeriesMgt.SetSeries("No.");
            Rec:=LoadingAuthHeader;
            exit(true);
        end;
    end;
    // end;
    local procedure TestNoSeries(): Boolean begin
        SalesSetup.TestField("Product Release Memo Nos.");
    end;
    local procedure GetNoSeriesCode(): Code[10]begin
        exit(SalesSetup."Product Release Memo Nos.");
    end;
    procedure ValidateRequiredFields()begin
        TestField("Source Type");
        TestField("Approval Status", "Approval Status"::Open);
    // TestField("Customer No.");
    end;
    procedure ValidateOrderLines()begin
        CalcFields("Number of Orders");
        if "Number of Orders" = 0 then Error('Document must have at least one Sales Order to send for approval');
    end;
    procedure ResetDocument(CustNo: Code[20])var LALine: Record "Product Release Memo Line";
    begin
        TestField("Approval Status", "Approval Status"::Open);
        if Confirm('Are you sure you want to Reset Document ?', false)then begin
            LALine.Reset;
            LALine.SetRange("Document Type", LALine."Document Type"::"Product Release Memo");
            LALine.SetRange("Document No.", "No.");
            LALine.SetRange("Customer No.", CustNo);
            if LALine.FindSet then begin
                repeat LALine.Delete(true);
                until LALine.Next = 0;
            end;
        end;
    end;
    /// <summary>
 
/// MyProcedure. 
 
/// </summary>
 procedure AppendOrders()var Counter: Integer;
    PickInstructionLines: Record "Pick Instruction Line";
    Orders: Text[2048];
    begin
        Counter:=0;
        Clear(Orders);
        PickInstructionLines.SetRange("Document No.", Rec."No.");
        if PickInstructionLines.FindSet()then begin
            repeat if Counter > 0 then Orders:=StrSubstNo('%1%2', Orders, '|');
                Orders:=StrSubstNo('%1%2', Orders, PickInstructionLines."Order No.");
                Counter+=1;
            until PickInstructionLines.Next() = 0;
        end
        else
            Error('There Are No Orders');
        Rec.Validate("Sales Orders", Orders);
    end;
    /// <summary>
 
/// MarkOrders. 
 
/// </summary>
 
/// <returns>Return value of type Record "Sales Header".</returns>
 procedure MarkOrders(): Record "Sales Header" var PickInstructionLines: Record "Pick Instruction Line";
    SalesHeader2: Record "Sales Header";
    begin
        SalesHeader2.Reset();
        PickInstructionLines.SetRange("Document No.", Rec."No.");
        if PickInstructionLines.FindSet()then begin
            if SalesHeader2.Get(SalesHeader2."Document Type"::Order, PickInstructionLines."Order No.")then SalesHeader2.Mark(true);
        end;
        exit(SalesHeader2);
    end;
}
