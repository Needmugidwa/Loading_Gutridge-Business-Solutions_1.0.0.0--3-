pageextension 50205 CompInfo extends "Company Information"
{
    layout
    {
        addafter(Name)
        {
            field("Sales Order Loading";Rec."Sales Order Loading")
            {
                ToolTip = 'Specifies the value of the Sales Order Loading field.';
                ApplicationArea = All;
            }
        }
    }
}
