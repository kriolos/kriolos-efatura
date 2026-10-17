<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <ns prefix="ef" uri="urn:cv:dnre:efatura:v1"/>

    <!-- Carrega a lista de códigos a partir do ficheiro auxiliar -->
    <let name="codelists" value="doc('codelists-dnre.xml')"/>
    <let name="codigosIsencaoValidos" value="$codelists//isencoes/item/@code"/>
    <let name="codigosLocaisValidos" value="$codelists//locais/concelho/@code"/>

    <pattern id="ValidacaoTabelasReferencia">
        <!-- Valida motivo de isenção contra a tabela -->
        <rule context="ef:Line[ef:Tax/ef:TaxPercentage = 0]">
            <assert test="ef:Tax/ef:TaxExemptionReason = $codigosIsencaoValidos" flag="error">
                [DNRE-TAB-01] O motivo de isenção '<value-of select="ef:Tax/ef:TaxExemptionReason"/>' não consta da tabela oficial da DNRE.
            </assert>
        </rule>

        <!-- Valida código de concelho/local -->
        <rule context="ef:Header/ef:Emitter">
            <assert test="ef:Address/ef:CountyCode = $codigosLocaisValidos" flag="error">
                [DNRE-TAB-02] O código de localidade/concelho '<value-of select="ef:Address/ef:CountyCode"/>' é inválido.
            </assert>
        </rule>
    </pattern>
</schema>
