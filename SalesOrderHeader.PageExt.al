pageextension 50142 SalesOrderHeader extends "Sales Order"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("Location Code2";Rec."Location Code")
            {
                ApplicationArea = All;
                Caption = 'Location Code';
            }
        }
        addbefore(Status)
        {
            field("Blanket Order No";Rec."Blanket Order No.")
            {
                ApplicationArea = All;
            }
            field("Receipt No.";Rec."Receipt No.")
            {
                ToolTip = 'Specifies the value of the Receipt No. field.';
                ApplicationArea = All;
            }
            field("HQ Sup. Ref";Rec."HQ Sup. Ref")
            {
                ApplicationArea = All;
            }
            field("Pick Instructions";Rec."Pick Instructions")
            {
                ApplicationArea = All;
            }
        }
        addafter(Control1900201301)
        {
            group(Loading)
            {
                Caption = 'Loading';
                Visible = false;

                field("Loading Order No.";Rec."Loading Order No.")
                {
                    ApplicationArea = All;
                }
                field("Loading Date";Rec."Loading Date")
                {
                    ApplicationArea = All;
                }
                field("Trans Mode";Rec."Trans Mode")
                {
                    ApplicationArea = All;
                }
                field("Product To Load";Rec."Product To Load")
                {
                    ApplicationArea = All;
                }
                field("Transporter Code";Rec."Transporter Code")
                {
                    ApplicationArea = All;
                }
                field("Transporter Name";Rec."Transporter Name")
                {
                    ApplicationArea = All;
                }
                field("Horse Registration No.";Rec."Horse Registration No.")
                {
                    ApplicationArea = All;
                }
                field("No Trailer";Rec."No Trailer")
                {
                    ApplicationArea = All;
                }
                field("Trailer Registration No.";Rec."Trailer Registration No.")
                {
                    ApplicationArea = All;
                }
                field("Driver Code";Rec."Driver Code")
                {
                    ApplicationArea = All;
                }
                field("Driver ID";Rec."Driver ID")
                {
                    ApplicationArea = All;
                }
                field("Driver Name";Rec."Driver Name")
                {
                    ApplicationArea = All;
                }
                field(QtyToLoad;Rec.QtyToLoad)
                {
                    Caption = 'Qty. to Load';
                    ApplicationArea = All;
                }
                field(AddToLines;Rec.AddToLines)
                {
                    ApplicationArea = All;
                    Caption = 'Add to Lines';
                }
            }
            group("")
            {
                Visible = false;
                Caption = 'Loading Details (Cont)';

                field("Meter Code";Rec."Meter Code")
                {
                    ApplicationArea = All;
                }
                field("Opening Meter Reading";Rec."Opening Meter Reading")
                {
                    ApplicationArea = All;
                }
                field("Closing Meter Reading";Rec."Closing Meter Reading")
                {
                    ApplicationArea = All;
                }
                field("Batch Qty Uplifted";Rec."Batch Qty Uplifted")
                {
                    ApplicationArea = All;
                }
                field(Variance;Rec.Variance)
                {
                    ApplicationArea = All;
                }
                field(Loader;Rec.Loader)
                {
                    ApplicationArea = All;
                }
                field(Dipper;Rec.Dipper)
                {
                    ApplicationArea = All;
                }
                field(Sealer;Rec.Sealer)
                {
                    ApplicationArea = All;
                }
                field("Quantity At 20 Degrees";Rec."Quantity At 20 Degrees")
                {
                    ApplicationArea = All;
                }
                field("Conversion Factor";Rec."Conversion Factor")
                {
                    ApplicationArea = All;
                }
                field("Dip Temperature";Rec."Dip Temperature")
                {
                    ApplicationArea = All;
                }
                field("Loading Badge No.";Rec."Loading Badge No.")
                {
                    ApplicationArea = All;
                }
                field("Loading Time";Rec."Loading Time")
                {
                    ApplicationArea = All;
                }
                field("Loaded by User";Rec."Loaded by User")
                {
                    ApplicationArea = All;
                }
                field("Awaiting Posting";Rec."Awaiting Posting")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        addafter(Approval)
        {
            group(Picking)
            {
                Caption = 'Picking';
                Image = PickLines;

                // ApplicationArea = All;
                action("Picking Instruction")
                {
                    Image = InventoryPick;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()var PickInstruction: Record "Pick Instruction Header";
                    PickInstr: Page "Pick Instruction List";
                    begin
                        PickInstr.Run();
                    end;
                }
                Action("Print Release Memo")
                {
                    Image = Print;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()var myInt: Integer;
                    ReleaseMemo: Report "Product Release Memo";
                    SalesHdrRec: Record "Sales Header";
                    begin
                        // SalesHdrRec.SetCurrentKey("No.");
                        // ReleaseMemo.SetTableView(SalesHdrRec);
                        // ReleaseMemo.UseRequestPage(False);
                        // ReleaseMemo.Run();
                        //Report.Print(50104, Rec."No.");
                        Rec.TestField(Status, Rec.Status::Released);
                        Rec.SetRange("No.", Rec."No.");
                        Rec.SetRecFilter();
                        Report.Run(report::"Product Release Memo", true, false, Rec);
                    end;
                }
            }
        }
    }
}
