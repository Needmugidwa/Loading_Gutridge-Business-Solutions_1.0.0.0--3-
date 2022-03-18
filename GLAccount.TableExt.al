tableextension 50147 GLAccount extends "G/L Account"
{
    fields
    {
        field(50000;"Sale Account";Boolean)
        {
        }
        field(50001;"Fiscal VAT";Boolean)
        {
            Description = 'Fiscal';
        }
    }
}
