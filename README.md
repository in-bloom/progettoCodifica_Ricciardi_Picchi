# Comandi utili

## Per validare XML con DTD

```bash
java -cp "./percorso/to/xerces/\*" dom.Counter -v file.xml
```

## Articoli scelti per ora

- Fascicolo 13: I conservatori di musica in Italia (forse anche bibliografia e notizie)
- Fascicolo 26: Il socialismo in Italia
- Fascicolo 96: Corrispondenza da Berlino

```bash
java -cp "SaxonHE12-5J/*" \
  -Djdk.xml.entityExpansionLimit=100000 \
  net.sf.saxon.Transform -s:prova_tei.xml -xsl:transformer.xsl -o:output.html
```
