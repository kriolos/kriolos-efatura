<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <ns prefix="ef" uri="urn:cv:dnre:efatura:v1"/>

  <!-- Padrão: Regras de Cabeçalho e Identificação -->
  <pattern id="DNRE-Header-Rules">
    <rule context="ef:Header">
      <!-- Validação de NIF Emitente: Cabo Verde possui 9 dígitos numéricos -->
      <assert test="matches(ef:TaxRegistrationNumber, '^[123][0-9]{8}$')" flag="error">
        [DNRE-01] O NIF do emitente deve conter exatamente 9 dígitos e iniciar por 1, 2 ou 3.
      </assert>

      <!-- Validação cronológica de emissão vs registo no sistema -->
      <assert test="xs:dateTime(ef:SystemEntryDate) &gt;= xs:dateTime(ef:InvoiceDate)" flag="error">
        [DNRE-02] A data de gravação no sistema (SystemEntryDate) não pode ser anterior à data de emissão (InvoiceDate).
      </assert>
    </rule>
  </pattern>

  <!-- Padrão: IVA e Motivos de Isenção -->
  <pattern id="DNRE-Tax-Rules">
    <rule context="ef:Line">
      <!-- Se a taxa de IVA for 0%, o código de motivo de isenção é mandatório -->
      <assert test="not(ef:Tax/ef:TaxPercentage = 0) or (string-length(normalize-space(ef:Tax/ef:TaxExemptionReason)) &gt; 0)" flag="error">
        [DNRE-03] Para linhas com taxa de IVA a 0%, é obrigatório especificar o código de motivo de isenção.
      </assert>

      <!-- Preço unitário e quantidades não podem ser negativos -->
      <assert test="xs:decimal(ef:UnitPrice) &gt;= 0 and xs:decimal(ef:Quantity) &gt; 0" flag="error">
        [DNRE-04] Quantidade deve ser superior a zero e preço unitário não pode ser negativo.
      </assert>
    </rule>
  </pattern>

  <!-- Padrão: Totais e Consistência Aritmética -->
  <pattern id="DNRE-Totals-Rules">
    <rule context="ef:DocumentTotals">
      <!-- GrossTotal deve ser rigorosamente a soma de NetTotal com TaxPayable -->
      <assert test="abs(xs:decimal(ef:GrossTotal) - (xs:decimal(ef:NetTotal) + xs:decimal(ef:TaxPayable))) &lt; 0.01" flag="error">
        [DNRE-05] Divergência no total bruto: GrossTotal deve ser igual à soma de NetTotal e TaxPayable.
      </assert>
    </rule>
  </pattern>
</schema>
