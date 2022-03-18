tableextension 50140 SalesHdrExt extends "Sales Header"
{
    fields
    {
        field(50000;"Receipt No.";Code[20])
        {
            trigger OnValidate()begin
                UpdateSalesLines(FieldCaption("Receipt No."), CurrFieldNo <> 0);
            end;
        }
        field(50001;"Batch No.";Code[20])
        {
        }
        field(50002;"Loading Order No.";Code[20])
        {
            trigger OnLookup()var FilteredLoadingTickets: Record "Loading Ticket";
            LAHeader: Record "Product Release Memo Header";
            begin
                ReleaseMemoFunctions.CheckIsProductReleaseMemoReady(Rec, true); //LAW18.00
                //>>>>> CompSepW17.00 kuda 16-03-17
                CompInfo.Get();
                // if CompInfo."Sales Order Loading" then begin //>>CompSepW17.00 kuda 16-03-17
                FilteredLoadingTickets.RESET;
                case "Document Type" of "Document Type"::Order: begin
                    FilterText:=UserMgt.GetUserLocationFilter();
                    if FilterText = '' then Error(Text50005, UserId)
                    else
                    begin
                        FilteredLoadingTickets.FILTERGROUP(2);
                        FilteredLoadingTickets.SETCURRENTKEY("Location Code", "Loading Order No. Used");
                        FilteredLoadingTickets.SETFILTER("Location Code", FilterText);
                        FilteredLoadingTickets.SETFILTER("Loading Order No. Used", '%1', false);
                        FilteredLoadingTickets.FILTERGROUP(0);
                        if PAGE.RunModal(0, FilteredLoadingTickets) = ACTION::LookupOK then Validate("Loading Order No.", FilteredLoadingTickets."Loading Order No.");
                    end;
                end;
                end;
            // end //>>CompSepW17.00 kuda 16-03-17
            end;
            trigger OnValidate()var LoadingTicket: Record "Loading Ticket";
            begin
                //SandRSetup.FINDFIRST;//>>>>> CompSepW17.00 kuda 16-03-17
                CompInfo.Get();
                // if CompInfo."Sales Order Loading" then begin //>>CompSepW17.00 kuda 16-03-17
                ReleaseMemoFunctions.CheckIsProductReleaseMemoReady(Rec, true); //LAW18.00
                //PDK01 - 16.03.09 - Start
                if not LoadingTicket.GET("Loading Order No.")then "Loading Location":=''
                else
                begin
                    if LoadingTicket."Loading Order No. Used" then Error('Loading Order No.: %1 is already used.', LoadingTicket."Loading Order No.");
                    LoadingTicket.TESTFIELD("Item To Load");
                    Validate("Product To Load", LoadingTicket."Item To Load");
                    "Loading Location":=LoadingTicket."Location Code";
                    UpdateSalesLines(FieldCaption("Loading Order No."), CurrFieldNo <> 0);
                    //PDK01 - 16.03.09 - End;
                    // SalesSetup1.Get;
                    // if ("Receipt No." = '') and (not SalesSetup1."Product Release Memo Mandatory") then //<<LAW18.00
                    //     Error(Text50003);
                    "Loading Date":=Today;
                    Modify();
                end;
            end; //<<CompSepW17.00 kuda  16-03-17
        // end;
        }
        field(50003;"Loading Date";Date)
        {
        }
        field(50004;"Opening Meter Reading";Decimal)
        {
        }
        field(50005;"Closing Meter Reading";Decimal)
        {
            trigger OnValidate()var SaleslineCopy: Record "Sales Line";
            begin
                TestField("Product To Load");
                TestField(QtyToLoad);
                "Batch Qty Uplifted":="Closing Meter Reading" - "Opening Meter Reading";
                Variance:="Batch Qty Uplifted" - QtyToLoad;
                if SaleslineCopy.Get("Document Type", "No.", "Current Line No. to Load")then begin
                    SaleslineCopy.TestField("No.", "Product To Load");
                    SaleslineCopy.TestField("Location Code", "Loading Location");
                    SalesSetup1.Get;
                    if "Trans Mode" = "Trans Mode"::"Road Tanker" then if "Batch Qty Uplifted" > SalesSetup1."Road Tanker Max Qty to Load" then Error('You cannot load more than %1 L for\' + 'Transport Mode: Road Tanker', SalesSetup1."Road Tanker Max Qty to Load");
                    SaleslineCopy.Validate("Qty. to Ship", "Batch Qty Uplifted");
                    SaleslineCopy.Modify;
                end;
            end;
        }
        field(50006;"Meter Code";Code[20])
        {
            TableRelation = "Meter Codes" WHERE("Location Code"=FIELD("Loading Location"));
        }
        field(50007;Loader;Code[50])
        {
            TableRelation = "Loading Personnel" WHERE("Location Code"=FIELD("Loading Location"));
        }
        field(50008;Dipper;Code[50])
        {
            TableRelation = "Loading Personnel" WHERE("Location Code"=FIELD("Loading Location"));
        }
        field(50009;Sealer;Code[50])
        {
            TableRelation = "Loading Personnel" WHERE("Location Code"=FIELD("Loading Location"));
        }
        field(50010;"Transporter Name";Text[50])
        {
        }
        field(50011;"Horse Registration No.";Code[20])
        {
            Description = 'LoadingW20.10';
            TableRelation = "Truck Registration" WHERE(Type=CONST(Horse));
            ValidateTableRelation = false;

            trigger OnValidate()var TruckRegistration: Record "Truck Registration";
            begin
                Rec.TestField("Trans Mode", Rec."Trans Mode"::"Road Tanker");
                if "Horse Registration No." = '' then exit;
                if TruckRegistration.GET("Horse Registration No.")then TruckRegistration.TESTFIELD(Type, TruckRegistration.Type::Horse)
                else
                begin
                    TruckRegistration.INIT;
                    TruckRegistration."Registration No.":="Horse Registration No.";
                    TruckRegistration.Type:=TruckRegistration.Type::Horse;
                    TruckRegistration.INSERT;
                end;
            end;
        }
        field(50012;"Driver Name";Text[50])
        {
            Editable = false;

            trigger OnValidate()begin
                Rec.TestField("Trans Mode", Rec."Trans Mode"::"Road Tanker");
            end;
        }
        field(50013;"Driver ID";Code[20])
        {
            trigger OnValidate()begin
                Rec.TestField("Trans Mode", Rec."Trans Mode"::"Road Tanker");
            end;
        }
        field(50014;"Batch Qty Uplifted";Decimal)
        {
        }
        field(50015;"Compartments with Dips";Decimal)
        {
        }
        field(50016;"Qty Per Compartment";Decimal)
        {
        }
        field(50017;"Quantity At 20 Degrees";Decimal)
        {
        }
        field(50018;"Conversion Factor";Decimal)
        {
            DecimalPlaces = 6: 6;
        }
        field(50019;"Dip Temperature";Decimal)
        {
        }
        field(50020;"Dip Value 1";Decimal)
        {
            trigger OnValidate()begin
                ValidateQTyToLoad("Dip Value 1", "Dip Value 2", "Dip Value 3", "Dip Value 4", "Dip Value 5", "Dip Value 6", "Dip Value 7", "Dip Value 8", "Dip Value 9", "Dip Value 10", "Dip Value 11", "Dip Value 12");
            end;
        }
        field(50021;"Dip Value 2";Decimal)
        {
            trigger OnValidate()begin
                ValidateQTyToLoad("Dip Value 1", "Dip Value 2", "Dip Value 3", "Dip Value 4", "Dip Value 5", "Dip Value 6", "Dip Value 7", "Dip Value 8", "Dip Value 9", "Dip Value 10", "Dip Value 11", "Dip Value 12");
            end;
        }
        field(50022;"Dip Value 3";Decimal)
        {
            trigger OnValidate()begin
                ValidateQTyToLoad("Dip Value 1", "Dip Value 2", "Dip Value 3", "Dip Value 4", "Dip Value 5", "Dip Value 6", "Dip Value 7", "Dip Value 8", "Dip Value 9", "Dip Value 10", "Dip Value 11", "Dip Value 12");
            end;
        }
        field(50023;"Dip Value 4";Decimal)
        {
            trigger OnValidate()begin
                ValidateQTyToLoad("Dip Value 1", "Dip Value 2", "Dip Value 3", "Dip Value 4", "Dip Value 5", "Dip Value 6", "Dip Value 7", "Dip Value 8", "Dip Value 9", "Dip Value 10", "Dip Value 11", "Dip Value 12");
            end;
        }
        field(50024;"Dip Value 5";Decimal)
        {
            trigger OnValidate()begin
                ValidateQTyToLoad("Dip Value 1", "Dip Value 2", "Dip Value 3", "Dip Value 4", "Dip Value 5", "Dip Value 6", "Dip Value 7", "Dip Value 8", "Dip Value 9", "Dip Value 10", "Dip Value 11", "Dip Value 12");
            end;
        }
        field(50025;"Dip Value 6";Decimal)
        {
            trigger OnValidate()begin
                ValidateQTyToLoad("Dip Value 1", "Dip Value 2", "Dip Value 3", "Dip Value 4", "Dip Value 5", "Dip Value 6", "Dip Value 7", "Dip Value 8", "Dip Value 9", "Dip Value 10", "Dip Value 11", "Dip Value 12");
            end;
        }
        field(50026;"Dip Value 7";Decimal)
        {
            trigger OnValidate()begin
                ValidateQTyToLoad("Dip Value 1", "Dip Value 2", "Dip Value 3", "Dip Value 4", "Dip Value 5", "Dip Value 6", "Dip Value 7", "Dip Value 8", "Dip Value 9", "Dip Value 10", "Dip Value 11", "Dip Value 12");
            end;
        }
        field(50027;"Dip Value 8";Decimal)
        {
            trigger OnValidate()begin
                ValidateQTyToLoad("Dip Value 1", "Dip Value 2", "Dip Value 3", "Dip Value 4", "Dip Value 5", "Dip Value 6", "Dip Value 7", "Dip Value 8", "Dip Value 9", "Dip Value 10", "Dip Value 11", "Dip Value 12");
            end;
        }
        field(50028;"Dip Value 9";Decimal)
        {
            trigger OnValidate()begin
                ValidateQTyToLoad("Dip Value 1", "Dip Value 2", "Dip Value 3", "Dip Value 4", "Dip Value 5", "Dip Value 6", "Dip Value 7", "Dip Value 8", "Dip Value 9", "Dip Value 10", "Dip Value 11", "Dip Value 12");
            end;
        }
        field(50029;"Dip Value 10";Decimal)
        {
            trigger OnValidate()begin
                ValidateQTyToLoad("Dip Value 1", "Dip Value 2", "Dip Value 3", "Dip Value 4", "Dip Value 5", "Dip Value 6", "Dip Value 7", "Dip Value 8", "Dip Value 9", "Dip Value 10", "Dip Value 11", "Dip Value 12");
            end;
        }
        field(50030;"Dip Value 11";Decimal)
        {
            trigger OnValidate()begin
                ValidateQTyToLoad("Dip Value 1", "Dip Value 2", "Dip Value 3", "Dip Value 4", "Dip Value 5", "Dip Value 6", "Dip Value 7", "Dip Value 8", "Dip Value 9", "Dip Value 10", "Dip Value 11", "Dip Value 12");
            end;
        }
        field(50031;"Dip Value 12";Decimal)
        {
            trigger OnValidate()begin
                ValidateQTyToLoad("Dip Value 1", "Dip Value 2", "Dip Value 3", "Dip Value 4", "Dip Value 5", "Dip Value 6", "Dip Value 7", "Dip Value 8", "Dip Value 9", "Dip Value 10", "Dip Value 11", "Dip Value 12");
            end;
        }
        field(50032;"Conv Qty 1";Decimal)
        {
        }
        field(50033;"Conv Qty 2";Decimal)
        {
        }
        field(50034;"Conv Qty 3";Decimal)
        {
        }
        field(50035;"Conv Qty 4";Decimal)
        {
        }
        field(50036;"Conv Qty 5";Decimal)
        {
        }
        field(50037;"Conv Qty 6";Decimal)
        {
        }
        field(50038;"Conv Qty 7";Decimal)
        {
        }
        field(50039;"Conv Qty 8";Decimal)
        {
        }
        field(50040;"Conv Qty 9";Decimal)
        {
        }
        field(50041;"Conv Qty 10";Decimal)
        {
        }
        field(50042;"Conv Qty 11";Decimal)
        {
        }
        field(50043;"Conv Qty 12";Decimal)
        {
        }
        field(50044;AddToLines;Boolean)
        {
        }
        field(50045;AddToLinesRec;Boolean)
        {
        }
        field(50046;ApplyToAll;Boolean)
        {
        }
        field(50047;"Trans Mode";Option)
        {
            OptionCaption = ' ,Road Tanker,Rail Tanker,Pipe line';
            OptionMembers = " ", "Road Tanker", "Rail Tanker", "Pipe line";
        }
        field(50048;QtyToLoad;Decimal)
        {
            NotBlank = false;

            trigger OnValidate()var SalesLine: Record "Sales Line";
            begin
                TestField("Product To Load");
                SalesLine.Reset;
                SalesLine.SetRange("Document Type", "Document Type");
                SalesLine.SetRange("Document No.", "No.");
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetFilter("No.", "Product To Load");
                // SalesLine.SetRange("Location Code", "Loading Location");
                // SalesLine.SetFilter("Outstanding Quantity", '>=%1', QtyToLoad);
                // SalesLine.FindFirst;
                if SalesLine.FindSet()then repeat SalesLine.Validate("Location Code", rec."Loading Location");
                        SalesLine.Modify();
                    until SalesLine.Next() = 0;
                SalesSetup1.Get;
                SalesSetup1.TestField("Road Tanker Max Qty to Load"); //<<RoadTankerQty
                if "Trans Mode" = "Trans Mode"::"Road Tanker" then if QtyToLoad > SalesSetup1."Road Tanker Max Qty to Load" then Error('You cannot load more than %1 L for\' + 'Transport Mode: Road Tanker', SalesSetup1."Road Tanker Max Qty to Load"); //<<RoadTankerQty
                SalesLine.Validate("Qty. to Ship", QtyToLoad);
                SalesLine.Modify;
                "Current Line No. to Load":=SalesLine."Line No.";
                SalesLine.Reset;
                SalesLine.SetRange("Document Type", "Document Type");
                SalesLine.SetRange("Document No.", "No.");
                SalesLine.SetFilter("Line No.", '<>%1', "Current Line No. to Load");
                if SalesLine.FindFirst then repeat SalesLine.Validate("Qty. to Ship", 0);
                        SalesLine.Modify;
                    until SalesLine.Next = 0;
            end;
        }
        field(50049;Variance;Decimal)
        {
        }
        field(50050;"Product To Load";Code[20])
        {
            Editable = false;
            TableRelation = Item."No." WHERE("Product to load"=CONST(true));
        }
        field(50051;"Uplift Date";Date)
        {
            Editable = false;
        }
        field(50052;"HQ Sup. Ref";Code[20])
        {
            trigger OnValidate()begin
                if "Document Type" = "Document Type"::"Blanket Order" then begin
                    if SalesLinesExist then TestField("HQ Sup. Ref");
                    // SalesInvHdr.SetCurrentKey("HQ Sup. Ref");
                    // SalesInvHdr.SetRange("HQ Sup. Ref", "HQ Sup. Ref");
                    // if SalesInvHdr.FindFirst then
                    //     Error('HQ Sup. Ref %1 Already Exist in the system', "HQ Sup. Ref");
                    SalesHdr.Reset;
                    SalesHdr.SetRange("Document Type", SalesHdr."Document Type"::"Blanket Order");
                    SalesHdr.SetCurrentKey("HQ Sup. Ref");
                    SalesHdr.SetRange("HQ Sup. Ref", "HQ Sup. Ref");
                    SalesHdr.SetFilter("No.", '<>%1', "No.");
                    if SalesHdr.FindFirst then Error('HQ Sup. Ref %1 has already been used on Blanket Sales Order No. %2', "HQ Sup. Ref", SalesHdr."No.");
                end;
            end;
        }
        field(50053;"Depot DEL. Note No.";Code[20])
        {
        }
        field(50054;"PETROTRADE DEL. Note No.";Code[20])
        {
        }
        field(50055;"Drv Name";Text[30])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(50056;"Loading Authority";Code[20])
        {
            trigger OnValidate()var LoadingTicket: Record "Loading Ticket";
            begin
                CompInfo.Get();
                if CompInfo."Sales Order Loading" then begin //>>CompSepW17.00 kuda 16-03-17
                    SalesInvHdr.SetCurrentKey("Loading Authority");
                    SalesInvHdr.SetRange("Loading Authority", "Loading Authority");
                    if SalesInvHdr.FindFirst then Error('Loading Authority ALREADY EXISTS');
                    SalesHdr.SetCurrentKey("Loading Authority");
                    SalesHdr.SetRange("Loading Authority", "Loading Authority");
                    if SalesHdr.FindFirst then Error('Loading Authority ALREADY USED');
                end //>>CompSepW17.00 kuda 16-03-17
 end;
        }
        field(50058;"Blanket Order No.";Code[20])
        {
            Caption = 'Blanket Order No.';
            Editable = false;
        //This property is currently not supported
        //TestTableRelation = false;
        }
        field(50060;"Posting Time";DateTime)
        {
            Editable = false;
        }
        field(50061;"Lookup Location";Code[20])
        {
            CalcFormula = Lookup("Sales Line"."Location Code" WHERE("Document Type"=FIELD("Document Type"), "Document No."=FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50062;"Item Type Exist";Boolean)
        {
            CalcFormula = Exist("Sales Line" WHERE("Document Type"=FIELD("Document Type"), "Document No."=FIELD("No."), Type=CONST(Item)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50070;"Transport Mode";Option)
        {
            OptionCaption = ' ,Road,Rail,Export Road,Export Rail,Pipeline';
            OptionMembers = " ", Road, Rail, "Export Road", "Export Rail", Pipeline;
        }
        field(50076;"Service Charges Incl.";Option)
        {
            OptionCaption = 'Both Charges,Duty Charges,Zinara Charges,No Charges';
            OptionMembers = "Both Charges", "Duty Charges", "Zinara Charges", "No Charges";

            trigger OnValidate()var StatutoryLines: Record "Sales Line";
            confirm: Boolean;
            change: Option "Both Charges", "Duty Charges", "Zinara Charges";
            begin
                //>>STATUTORY--Remove statutory ines upon exemption
                TestField(Status, Status::Open);
                if "Service Charges Incl." = "Service Charges Incl."::"No Charges" then begin
                    StatutoryLines.SetRange(StatutoryLines."Document No.", "No.");
                    StatutoryLines.SetRange(StatutoryLines."Statutory Line", true);
                    if StatutoryLines.FindSet then StatutoryLines.DeleteAll;
                end
                else
                begin
                    StatutoryLines.SetRange(StatutoryLines."Document No.", "No.");
                    StatutoryLines.SetRange(StatutoryLines."Statutory Line", true);
                    if StatutoryLines.FindSet then StatutoryLines.DeleteAll;
                end;
            //<<STATUTORY---Remove statutory lines upon exemption
            end;
        }
        field(50077;"Nav 2009 Ref No.";Code[20])
        {
            Description = 'SORDREF';
        }
        field(50078;"Zinara Charges";Boolean)
        {
            Description = 'StatutoryW18.00';

            trigger OnValidate()begin
                // >>StatutoryW18.00
                TestField(Status, Status::Open);
                if not "Zinara Charges" then "All Service Charges":=false;
                // <<StatutoryW18.00
                CheckStatutoryLine; //<<LAW18.00
            end;
        }
        field(50079;"Duty Charges";Boolean)
        {
            Description = 'StatutoryW18.00';

            trigger OnValidate()begin
                // >>StatutoryW18.00
                TestField(Status, Status::Open);
                if not "Duty Charges" then "All Service Charges":=false;
                // <<StatutoryW18.00
                CheckStatutoryLine; //<<LAW18.00
            end;
        }
        field(50080;"Pipeline Local Fee Charges";Boolean)
        {
            Description = 'StatutoryW18.00';

            trigger OnValidate()begin
                // >>StatutoryW18.00
                TestField(Status, Status::Open);
                if not "Pipeline Local Fee Charges" then "All Service Charges":=false;
                // <<StatutoryW18.00
                CheckStatutoryLine; //<<LAW18.00
            end;
        }
        field(50081;"Storage and Handling - Local";Boolean)
        {
            Description = 'StatutoryW18.00';

            trigger OnValidate()begin
                // >>StatutoryW18.00
                TestField(Status, Status::Open);
                if not "Storage and Handling - Local" then "All Service Charges":=false;
                // <<StatutoryW18.00
                CheckStatutoryLine; //<<LAW18.00
            end;
        }
        field(50082;"All Service Charges";Boolean)
        {
            Description = 'StatutoryW18.00';

            trigger OnValidate()begin
                // >>StatutoryW18.00
                TestField(Status, Status::Open);
                if "All Service Charges" then begin
                    "Zinara Charges":=true;
                    "Duty Charges":=true;
                    "Pipeline Local Fee Charges":=true;
                    "Storage and Handling - Local":=true;
                    "Storage and Handling - Foreign":=true;
                    "Pipeline Foreign Fee Charges":=true;
                end
                else
                begin
                    "Zinara Charges":=false;
                    "Duty Charges":=false;
                    "Pipeline Local Fee Charges":=false;
                    "Storage and Handling - Local":=false;
                    "Storage and Handling - Foreign":=false;
                    "Pipeline Foreign Fee Charges":=false;
                end;
                // <<StatutoryW18.00
                CheckStatutoryLine; //<<LAW18.00
            end;
        }
        field(50083;"Product Release Memo No.";Code[20])
        {
            Caption = 'Product Release Memo No.';
            Description = 'LAW18.00';
            Editable = false;

            trigger OnValidate()var LoadingAuth: Record "Product Release Memo Header";
            begin
                // FM LAW18.00
                if "Product Release Memo No." <> '' then begin //FM LAW18.00
                    LoadingAuth.GET(LoadingAuth."Document Type"::"Product Release Memo", "Product Release Memo No.");
                    LoadingAuth.TESTFIELD(LoadingAuth."Approval Status", LoadingAuth."Approval Status"::Released);
                end;
            // FM LAW18.00
            end;
        }
        field(50084;"Statutory Invoice No.";Code[20])
        {
            Description = 'LAW18.00';
            Editable = false;
            TableRelation = "Sales Invoice Header"."No." WHERE("Sell-to Customer No."=FIELD("Sell-to Customer No."));

            trigger OnLookup()var PostedInvoice: Record "Sales Invoice Header";
            begin
                if "Statutory Invoice No." <> '' then begin
                    ViewSalesInvoice;
                end;
            end;
            trigger OnValidate()var PostedInvoice: Record "Sales Invoice Header";
            begin
            end;
        }
        field(50086;"Statutory Balance";Decimal)
        {
            Description = 'LAW18.00';
        }
        field(50087;"Is Statutory Invoice";Boolean)
        {
            CalcFormula = Exist("Sales Line" WHERE("Document Type"=CONST(Invoice), "Is Statutory Line"=CONST(true), "Document No."=FIELD("No.")));
            Description = 'LAW18.00';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50088;"Has Statutory Balance";Boolean)
        {
            Description = 'LAW18.00';
            Editable = false;
        }
        field(50089;"No. of Lines";Integer)
        {
            CalcFormula = Count("Sales Line" WHERE("Document Type"=FIELD("Document Type"), "Document No."=FIELD("No.")));
            Description = 'LAW18.00';
            FieldClass = FlowField;
        }
        field(50090;"Special Order Type";Option)
        {
            Description = 'LAW19.00';
            OptionCaption = ' ,Duty Free,Export,Special Product';
            OptionMembers = " ", "Duty Free", Export, "Special Product";
        }
        field(50091;"Zimra Bill of Entry/Ref. No.";Code[20])
        {
            Description = 'LAW19.00';

            trigger OnValidate()begin
                TestField(Status, Status::Open);
                TestField("Document Type", "Document Type"::Order);
                TestField("Special Order Type");
            end;
        }
        field(50092;"Total Item Qty";Decimal)
        {
            CalcFormula = Sum("Sales Line".Quantity WHERE("Document Type"=FIELD("Document Type"), "Document No."=FIELD("No."), Type=CONST(Item)));
            Description = 'LAW20.00';
            FieldClass = FlowField;
        }
        field(50093;"Transporter Code";Code[20])
        {
            Description = 'LoadingW20.00';
            TableRelation = Transporter;

            trigger OnValidate()var Transporter: Record Transporter;
            begin
                if Transporter.GET("Transporter Code")then "Transporter Name":=Transporter.Name
                else
                    "Transporter Name":='';
            end;
        }
        field(50094;"Driver Code";Code[20])
        {
            Description = 'LoadingW20.00';
            TableRelation = "Transporter Driver".Code WHERE("Transpoter Code"=FIELD("Transporter Code"), Status=const(Enabled), "National ID No."=FILTER(<>''));

            trigger OnValidate()var TransporterDriver: Record "Transporter Driver";
            begin
                TestField("Transporter Code");
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
        field(50095;"Loading Location";Code[10])
        {
            Description = 'LoadingW20.00 Current Loading Location Triggered by Loading Authority';
            TableRelation = Location;
        }
        field(50096;"Current Line No. to Load";Integer)
        {
            Description = 'LoadingW20.00';
        }
        field(50097;"Not Completely Invoiced";Boolean)
        {
            CalcFormula = Exist("Sales Line" WHERE("Outstanding Quantity"=FILTER(>0), "Document Type"=FIELD("Document Type"), "Document No."=FIELD("No.")));
            Description = 'LoadingW20.00';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50098;"Trailer Registration No.";Code[20])
        {
            Description = 'LoadingW20.10';
            TableRelation = "Truck Registration" WHERE(Type=CONST(Trailer));
            ValidateTableRelation = false;

            trigger OnValidate()var TruckRegistration: Record "Truck Registration";
            begin
                if "Trailer Registration No." = '' then exit;
                if TruckRegistration.GET("Trailer Registration No.")then TruckRegistration.TESTFIELD(Type, TruckRegistration.Type::Trailer)
                else
                begin
                    TruckRegistration.INIT;
                    TruckRegistration."Registration No.":="Trailer Registration No.";
                    TruckRegistration.Type:=TruckRegistration.Type::Trailer;
                    TruckRegistration.INSERT;
                end;
            end;
        }
        field(50099;"No Trailer";Boolean)
        {
            Description = 'LoadingW20.10';

            trigger OnValidate()begin
                Validate("Trailer Registration No.", '');
            end;
        }
        field(50100;"Amount (LCY)";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Amount (LCY)" WHERE("Document Type"=FIELD("Document Type"), "Document No."=FIELD("No.")));
            Caption = 'Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50101;"Amount Including VAT (LCY)";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Amount Including VAT (LCY)" WHERE("Document Type"=FIELD("Document Type"), "Document No."=FIELD("No.")));
            Caption = 'Amount Including VAT (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50200;"Loading Badge No.";Code[30])
        {
            Description = 'SatamW110.00';
            Editable = false;
        }
        field(50201;"Loading Time";DateTime)
        {
            Description = 'SatamW110.00';
            Editable = false;
        }
        field(50202;"Awaiting Posting";Boolean)
        {
            Description = 'SatamW110.00';
            Editable = false;
        }
        field(50203;"Loaded by User";Text[30])
        {
            Description = 'SatamW110.00';
            Editable = false;
        }
        field(50204;"Forced Deletion";Boolean)
        {
        }
        field(50205;"No. Of Active Quotes";Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Blanket Order No."=field("No."), "Document Type"=filter(Quote)));
            Editable = false;
        }
        field(50206;"No. Of Archived Quotes";Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Sales Header Archive" where("Blanket Order No."=field("No."), "Document Type"=filter(Quote)));
            Editable = false;
        }
        field(50209;"Statutory Document";Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50220;"Payment Receipt No.";Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Payment Header"."Receipt No." where("Source No."=field("No.")));
            TableRelation = "Payment Header"."Receipt No.";
            Editable = false;
        }
        field(50221;"Pick Instructions";Integer)
        {
            // DataClassification = ToBeClassified;
            // TableRelation = "Pick Instruction Header";
            FieldClass = FlowField;
            CalcFormula = count("Pick Instruction Line" where("Order No."=field("No.")));
            Editable = false;
        }
        field(50222;"Pipeline Foreign Fee Charges";Boolean)
        {
            Description = 'StatutoryW18.00';

            trigger OnValidate()begin
                // >>StatutoryW18.00
                TestField(Status, Status::Open);
                if not "Pipeline Foreign Fee Charges" then "All Service Charges":=false;
                // <<StatutoryW18.00
                CheckStatutoryLine; //<<LAW18.00
            end;
        }
        field(50223;"Storage and Handling - Foreign";Boolean)
        {
            Description = 'StatutoryW18.00';

            trigger OnValidate()begin
                // >>StatutoryW18.00
                TestField(Status, Status::Open);
                if not "Storage and Handling - Foreign" then "All Service Charges":=false;
                // <<StatutoryW18.00
                CheckStatutoryLine; //<<LAW18.00
            end;
        }
    }
    var Text50000: Label 'Sales  %1 No.  %2  does not exist in the  %3  table';
    SalesLine2: Record "Sales Line";
    Text55000: Label 'Please enter Dip Quantity for order no. %1';
    Text56000: Label 'Please enter Converted Quantity for order no. %1';
    FilterText: Text[1024];
    Text50005: Label 'User %1 is not allowed for any Locations.';
    Text50006: Label 'You must specify a Location.';
    Text50003: Label 'Please enter Receipt No.';
    UserMgt: Codeunit "Custom Sales Functions";
    LoadingAuthorityHeader: Record "Department Approval Setup";
    LoadingAuth: Record "Product Release Memo Header";
    CustLedgEntries: Page "Customer Ledger Entries";
    Custledg: Record "Cust. Ledger Entry";
    Text50007: Label 'Changing Statutory Invoice No. on a Sales Order with lines will delete the existing lines. Do you want to continue?';
    Text50008: Label 'Assigning Statutory Invoice No. on a Sales Order with lines will delete the existing lines. Do you want to continue?';
    Text50009: Label 'Do you want to assign Sales Order to an existing Product Release Memo? Click Yes to select Release Memo or click No to create new Release Memo.';
    Text50011: Label 'You are about to create new Product Release Memo and assign Sales Order. Do you want to continue? ';
    ReleaseMemoFunctions: Codeunit "Release Memo Functions";
    SalesInvHdr: Record "Sales Invoice Header";
    SalesHdr: Record "Sales Header";
    SalesSetup1: Record "Sales & Receivables Setup";
    CompInfo: Record "Company Information";
    SalesLine1: Record "Sales Line";
    procedure ViewOrderReceipt()begin
        Clear(CustLedgEntries);
        Custledg.Reset;
        CustLedgEntries.LookupMode(true);
        Custledg.SetCurrentKey("Sales Order No.");
        Custledg.SetRange("Sales Order No.", "No.");
        Custledg.FilterGroup(2);
        CustLedgEntries.SetTableView(Custledg);
        if ACTION::LookupOK = CustLedgEntries.RunModal then begin
            CustLedgEntries.GetRecord(Custledg);
            "Receipt No.":=Custledg."Document No.";
        end;
        Validate("Receipt No.");
    end;
    procedure ViewStatutoryInvoiceReceipt()begin
        Clear(CustLedgEntries);
        Custledg.Reset;
        CustLedgEntries.LookupMode(false);
        Custledg.SetCurrentKey("Document No.");
        Custledg.SetRange("Document No.", "Receipt No.");
        Custledg.SetRange("Customer No.", "Sell-to Customer No.");
        Custledg.FilterGroup(2);
        CustLedgEntries.SetTableView(Custledg);
        if ACTION::LookupOK = CustLedgEntries.RunModal then begin
            CustLedgEntries.GetRecord(Custledg);
        end;
    end;
    procedure ViewSalesInvoice()var SalesInvoices: Page "Posted Sales Invoices";
    SalesHdrInvoice: Record "Sales Invoice Header";
    begin
        Clear(SalesInvoices);
        SalesHdrInvoice.Reset;
        SalesInvoices.LookupMode(false);
        SalesHdrInvoice.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
        SalesHdrInvoice.SetRange("Has Statutory Balance", true);
        SalesHdrInvoice.FilterGroup(2);
        SalesInvoices.SetTableView(SalesHdrInvoice);
        if ACTION::LookupOK = SalesInvoices.RunModal then begin
        end;
    end;
    local procedure LookupReleaseMemo()var ReleaseMemoList: Page PageName;
    ReleaseMemoHeader: Record "Product Release Memo Header";
    begin
        Clear(ReleaseMemoList);
        ReleaseMemoHeader.RESET;
        ReleaseMemoList.LOOKUPMODE(true);
        ReleaseMemoHeader.SETRANGE("Customer No.", "Sell-to Customer No.");
        ReleaseMemoHeader.SETRANGE("Approval Status", ReleaseMemoHeader."Approval Status"::Open);
        ReleaseMemoHeader.FILTERGROUP(2);
        ReleaseMemoList.SETTABLEVIEW(ReleaseMemoHeader);
        if ACTION::LookupOK = ReleaseMemoList.RUNMODAL then begin
            ReleaseMemoList.GETRECORD(ReleaseMemoHeader);
            ReleaseMemoHeader.InsertOrderLine(Rec);
        end;
    end;
    local procedure CheckStatutoryLine()var StatutoryLine: Record "Sales Line";
    begin
        if "Document Type" = "Document Type"::Invoice then begin
            if(not "Zinara Charges") and (not "Duty Charges") and (not "Storage and Handling - Foreign") and (not "Pipeline Foreign Fee Charges") and (not "Storage and Handling - Local") and (not "Pipeline Local Fee Charges")then begin
                StatutoryLine.Reset;
                StatutoryLine.SetRange("Document Type", "Document Type");
                StatutoryLine.SetRange("Document No.", "No.");
                StatutoryLine.SetRange(Type, StatutoryLine.Type::Statutory);
                if StatutoryLine.FindFirst then Error('There must be at least one charge selected when there is a Statutory line.');
            end;
        end;
    end;
    procedure BlanketOrderPaidForQty(): Boolean var BlanketSalesOrderLine: Record "Sales Line";
    begin
        Rec.TestField("Document Type", Rec."Document Type"::"Blanket Order");
        BlanketSalesOrderLine.SetRange("Document Type", Rec."Document Type"::"Blanket Order");
        BlanketSalesOrderLine.SetRange("Document No.", Rec."No.");
        BlanketSalesOrderLine.SetFilter("Qty. Paid For", '<>%1', 0);
        if not BlanketSalesOrderLine.IsEmpty then exit(true);
        exit(false);
    end;
    local procedure ValidateQTyToLoad(Qty1: Decimal;
    Qty2: Decimal;
    Qty3: Decimal;
    Qty4: Decimal;
    Qty5: Decimal;
    Qty6: Decimal;
    Qty7: Decimal;
    Qty8: Decimal;
    Qty9: Decimal;
    Qty10: Decimal;
    Qty11: Decimal;
    Qty12: Decimal)begin
        Rec.TestField(QtyToLoad);
        if(Qty1 + Qty2 + Qty3 + Qty4 + Qty5 + Qty6 + Qty7 + Qty8 + Qty9 + Qty10 + Qty11 + Qty12) > Rec.QtyToLoad then Error('Quantities Exceed Qty. to load');
    end;
}
