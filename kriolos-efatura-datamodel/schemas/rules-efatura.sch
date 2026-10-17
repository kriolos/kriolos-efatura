<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
    <ns prefix="inv" uri="urn:cv:efatura:v1"/>

    <pattern id="TaxAndTotals">
        <!-- Check that gross total equals net + tax -->
        <rule context="inv:Invoice">
            <assert test="round(inv:GrossTotal * 100) = round((inv:NetTotal + inv:TaxTotal) * 100)">
                GrossTotal must be the exact sum of NetTotal and TaxTotal.
            </assert>
        </rule>
    
        <!-- Example: Adjusting minimum taxable base for withholding tax -->
        <rule context="inv:InvoiceLine">
            <assert test="inv:UnitPrice &gt; 0">
                Line unit price must be positive.
            </assert>
        </rule>

        <!-- Ensure exemption reason is present when tax rate is 0% -->
        <rule context="inv:InvoiceLine[inv:TaxRate = 0]">
            <assert test="string-length(normalize-space(inv:ExemptionReasonCode)) &gt; 0">
                Lines with 0% tax rate require an ExemptionReasonCode.
            </assert>
        </rule>
    </pattern>
</schema>
