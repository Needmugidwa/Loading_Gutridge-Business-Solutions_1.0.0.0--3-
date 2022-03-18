tableextension 50152 TransferRcptHdr extends "Transfer Receipt Header"
{
    fields
    {
        field(50000;"Memo Ref.  No.";Code[20])
        {
        }
        field(50001;"Batch No.";Code[20])
        {
        }
        field(50002;"Loading Order No.";Code[20])
        {
            TableRelation = "Loading Ticket";

            trigger OnValidate()begin
                TransferLine."Loading Order No.":="Loading Order No.";
            end;
        }
        field(50003;"Loading Date";Date)
        {
        }
        field(50004;"Opening Meter Reading";Decimal)
        {
        }
        field(50005;"Closing Meter Reading";Decimal)
        {
            trigger OnValidate()begin
                Variance:=0;
                "Batch Qty Uplifted":="Closing Meter Reading" - "Opening Meter Reading";
                Variance:=("Batch Qty Uplifted" - QtyToLoad);
            end;
        }
        field(50006;"Meter Code";Code[20])
        {
            TableRelation = "Meter Codes";
        }
        field(50007;Loader;Code[20])
        {
            TableRelation = "Loading Personnel";
        }
        field(50008;Dipper;Code[20])
        {
            TableRelation = "Loading Personnel";
        }
        field(50009;Sealer;Code[20])
        {
            TableRelation = "Loading Personnel";
        }
        field(50010;"Truck Name";Text[30])
        {
        }
        field(50011;"Truck Reg No.";Code[20])
        {
        }
        field(50012;"Driver Name";Text[30])
        {
        }
        field(50013;"Driver ID";Code[30])
        {
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
        field(50020;"Dip Qty 1";Decimal)
        {
        }
        field(50021;"Dip Qty 2";Decimal)
        {
        }
        field(50022;"Dip Qty 3";Decimal)
        {
        }
        field(50023;"Dip Qty 4";Decimal)
        {
        }
        field(50024;"Dip Qty 5";Decimal)
        {
        }
        field(50025;"Dip Qty 6";Decimal)
        {
        }
        field(50026;"Dip Qty 7";Decimal)
        {
        }
        field(50027;"Dip Qty 8";Decimal)
        {
        }
        field(50028;"Dip Qty 9";Decimal)
        {
        }
        field(50029;"Dip Qty 10";Decimal)
        {
        }
        field(50030;"Dip Qty 11";Decimal)
        {
        }
        field(50031;"Dip Qty 12";Decimal)
        {
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
        field(50047;TransMode;Option)
        {
            OptionCaption = ',Road Tanker, Rail Tanker';
            OptionMembers = , "Road Tanker", " Rail Tanker";
        }
        field(50048;QtyToLoad;Decimal)
        {
        }
        field(50049;Variance;Decimal)
        {
        }
        field(50050;"Drv Name";Text[30])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(50051;"HQ Reference";Text[30])
        {
        }
        field(50052;"Loading Authority No";Text[30])
        {
        }
    }
    var TransferLine: Record "Transfer Line";
}
