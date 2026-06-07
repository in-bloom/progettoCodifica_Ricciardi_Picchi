- ricontrolla che sia tutto ok anche nel xml
- riaggiusta header
- pagina about?
- test finale html con push
- elimina la branch fra

java -cp "SaxonHE12-5J/*" \
  -Djdk.xml.entityExpansionLimit=100000 \
  net.sf.saxon.Transform -s:La_Rassegna.xml -xsl:transformer.xsl -o:output.html