page 50104 "Pick Instruction"
{
    Caption = 'Pick Instruction';
    PageType = Card;
    SourceTable = "Pick Instruction Header";
    // UsageCategory = Administration;
    // ApplicationArea = All;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No.";Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Document Date";Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                    ApplicationArea = All;
                }
                field("Item No.";Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    ApplicationArea = All;
                }
                field("Customer No.";Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        CurrPage.Update();
                    end;
                }
                field("Customer Name";Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.';
                    ApplicationArea = All;
                }
                field("Has Lines";Rec."Has Lines")
                {
                    ToolTip = 'Specifies the value of the Has Lines field.';
                    ApplicationArea = All;
                }
                field("Loading Authority No.";Rec."Loading Authority No.")
                {
                    ToolTip = 'Specifies the value of the Loading Authority No. field.';
                    ApplicationArea = All;
                }
                field("Number of Orders";Rec."Number of Orders")
                {
                    ToolTip = 'Specifies the value of the Number of Orders field.';
                    ApplicationArea = All;
                }
                field("Total Qty to Load";Rec."Total Qty to Load")
                {
                    ToolTip = 'Specifies the value of the Total Qty to Load field.';
                    ApplicationArea = All;
                }
                field("Outstanding Quantity";Rec."Outstanding Quantity")
                {
                    ToolTip = 'Specifies the value of the Outstanding Quantity field.';
                    ApplicationArea = All;
                }
                field("Approval Status";Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Total Loaded Quantity";Rec."Total Loaded Quantity")
                {
                    ToolTip = 'Specifies the value of the Total Loaded Quantity field.';
                    ApplicationArea = All;
                }
                field("Sales Orders";Rec."Sales Orders")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
            }
            group(Loading)
            {
                field("Loading Location";Rec."Loading Location")
                {
                    ToolTip = 'Specifies the value of the Loading Location field.';
                    ApplicationArea = All;
                }
                field("Transport Mode";Rec."Transport Mode")
                {
                    ToolTip = 'Specifies the value of the Transport Mode field.';
                    ApplicationArea = All;
                }
                field("Transporter Code";Rec."Transporter Code")
                {
                    ToolTip = 'Specifies the value of the Transporter Code field.';
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        CurrPage.Update();
                    end;
                }
                field("Transporter Name";Rec."Transporter Name")
                {
                    ToolTip = 'Specifies the value of the Transporter Name field.';
                    ApplicationArea = All;
                }
                field("Meter Code";Rec."Meter Code")
                {
                    ToolTip = 'Specifies the value of the Meter Code field.';
                    ApplicationArea = All;
                }
                field(Dipper;Rec.Dipper)
                {
                    ToolTip = 'Specifies the value of the Dipper field.';
                    ApplicationArea = All;
                }
                field(Loader;Rec.Loader)
                {
                    ToolTip = 'Specifies the value of the Loader field.';
                    ApplicationArea = All;
                }
                field(Sealer;Rec.Sealer)
                {
                    ToolTip = 'Specifies the value of the Sealer field.';
                    ApplicationArea = All;
                }
                field("Horse Registration No.";Rec."Horse Registration No.")
                {
                    ToolTip = 'Specifies the value of the Horse Registration No. field.';
                    ApplicationArea = All;
                }
                field("Trailer Registration No.";Rec."Trailer Registration No.")
                {
                    ApplicationArea = All;
                }
                field("Driver Code";Rec."Driver Code")
                {
                    ToolTip = 'Specifies the value of the Driver Code field.';
                    ApplicationArea = All;
                }
                field("Driver ID";Rec."Driver ID")
                {
                    ToolTip = 'Specifies the value of the Driver ID field.';
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        CurrPage.Update();
                    end;
                }
                field("Driver Name";Rec."Driver Name")
                {
                    ToolTip = 'Specifies the value of the Driver Name field.';
                    ApplicationArea = All;
                }
            }
            part(Lines;"Pick Instruction Lines")
            {
                UpdatePropagation = Both;
                SubPageLink = "Document No."=field("No."), "Customer No."=field("Customer No.");
                ApplicationArea = ALl;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Apply)
            {
                ApplicationArea = All;
                Image = Apply;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()var PickInstrLines: Record "Pick Instruction Line";
                salesHeader: Record "Sales Header";
                SalesHeaderPost: Codeunit "Sales-Post (Yes/No)";
                begin
                    Rec.TestField("Approval Status", Rec."Approval Status"::Open);
                    Rec.TestField("Item No.");
                    rec.TestField("Customer No.");
                    rec.TestField("Loading Authority No.");
                    rec.TestField("Total Qty to Load");
                    Rec.CalcFields("Number of Orders");
                    rec.TestField("Number of Orders");
                    rec.TestField("Loading Location");
                    PickInstrLines.SetRange("Document No.", Rec."No.");
                    if PickInstrLines.FindSet()then repeat PickInstrLines.TestField("Qty To Load");
                            PickInstrLines.TestField("Qty. Loaded - @ 20", 0);
                            PickInstrLines.TestField("Qty. Loaded - Ambient", 0);
                        until PickInstrLines.Next() = 0;
                    Rec.AppendOrders();
                    Rec.Validate("Approval Status", rec."Approval Status"::Released);
                    Rec.Modify();
                    Message('Application Successful\Pick Instruction Released');
                end;
            }
            action(Post)
            {
                Caption = 'Post & Finish';
                Image = PostDocument;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()var PickInstrLines: Record "Pick Instruction Line";
                salesHeader: Record "Sales Header";
                SalesHeaderPost: Codeunit "Sales-Post (Yes/No)";
                SalesHeader2: Record "Sales Header";
                SelectionFilterManagement: Codeunit SelectionFilterManagement;
                ReleaseSalesDoc: Codeunit "Release Sales Document";
                begin
                    Rec.TestField("Approval Status", Rec."Approval Status"::Released);
                    Rec.TestField(Dipper);
                    Rec.TestField(Sealer);
                    Rec.TestField(Loader);
                    PickInstrLines.SetRange("Document No.", Rec."No.");
                    if PickInstrLines.FindSet()then repeat PickInstrLines.TestField("Qty. Loaded - @ 20");
                            PickInstrLines.TestField("Qty. Loaded - Ambient");
                            if salesHeader.get(salesHeader."Document Type"::Order, PickInstrLines."Order No.")then begin
                                // salesHeader.Validate("Pick Instr No.", Rec."No.");
                                if salesHeader.Status = salesHeader.Status::Released then ReleaseSalesDoc.PerformManualReopen(salesHeader);
                                salesHeader.Validate("Product To Load", Rec."Item No.");
                                salesHeader.Validate("Loading Location", Rec."Loading Location");
                                salesHeader.Validate("Batch Qty Uplifted", PickInstrLines."Qty. Loaded - Ambient");
                                salesHeader.Validate(QtyToLoad, PickInstrLines."Qty. Loaded - Ambient");
                                salesHeader.Modify();
                            // SalesHeaderPost.Run(salesHeader);
                            // PostSalesOrder(CODEUNIT::"Sales-Post (Yes/No)", "Navigate After Posting"::"Posted Document");
                            // salesHeader.Validate("Product To Load", '');
                            // salesHeader.Validate("Batch Qty Uplifted", 0);
                            // salesHeader.Validate(QtyToLoad, 0);
                            // salesHeader.Modify();
                            end;
                        until PickInstrLines.Next() = 0;
                    // SalesHeader2 := Rec.MarkOrders();
                    // CurrPage.SetSelectionFilter(SalesHeader2);
                    SalesHeader2.SetFilter("No.", Rec."Sales Orders"); //.GetSelectionFilterForSalesHeader(SalesHeader2));
                    REPORT.RunModal(REPORT::"Batch Post Sales Orders", false, true, SalesHeader2);
                    CurrPage.Update(false);
                    Rec.Validate("Approval Status", Rec."Approval Status"::Completed);
                end;
            }
            action(ReOpen)
            {
                ApplicationArea = All;
                Image = ReOpen;

                trigger OnAction()begin
                    Rec.TestField("Approval Status", Rec."Approval Status"::Released);
                    Rec.Validate("Sales Orders", '');
                    Rec.Validate("Approval Status", Rec."Approval Status"::Open);
                end;
            }
            Action(Print)
            {
                Image = Print;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()begin
                    Rec.SetRange("No.", Rec."No.");
                    Rec.SetRecFilter();
                    Report.Run(report::"Picking Slip", true, false, Rec);
                end;
            }
        }
    }
}
