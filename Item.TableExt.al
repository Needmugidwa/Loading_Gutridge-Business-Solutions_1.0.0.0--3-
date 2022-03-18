tableextension 50150 Item extends Item
{
    fields
    {
        field(50000;"Sales Item";Boolean)
        {
        }
        field(50001;HistInentory;Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("No."), "Global Dimension 1 Code"=FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code"=FIELD("Global Dimension 2 Filter"), "Location Code"=FIELD("Location Filter"), "Drop Shipment"=FIELD("Drop Shipment Filter"), "Variant Code"=FIELD("Variant Filter"), "Lot No."=FIELD("Lot No. Filter"), "Serial No."=FIELD("Serial No. Filter"), "Posting Date"=FIELD("Date Filter")));
            Caption = 'HistInentory';
            DecimalPlaces = 0: 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002;"Product to load";Boolean)
        {
        }
        field(50003;"Require Transport Mode";Option)
        {
            OptionCaption = 'Yes,No';
            OptionMembers = Yes, No;
        }
        field(50004;"Does Not Require Statutory Inv";Boolean)
        {
            Description = 'LAW19.00';
        }
    }
}
