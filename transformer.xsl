<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes" />

    <xsl:param name="mode" select="'original'" />

    <!-- <xsl:key name="glossario" match="tei:gloss" use="@target" /> -->

    <xsl:template match="/">
        <html>
            <head>
                <title><xsl:value-of select="//tei:titleStmt/tei:title"/></title>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <meta name="description" content="{normalize-space(//tei:encodingDesc/tei:projectDesc)}"/>
                <xsl:for-each select="//tei:titleStmt/tei:respStmt/tei:persName">
                    <meta name="author" content="{normalize-space(.)}"/>
                </xsl:for-each>

            </head>
            <body>
                <nav id="main-nav">

                    <ul class="nav-links">
                        <xsl:for-each select="//tei:div[@type='article' or @type='bibliography' or @type='section']">
                            <li>
                                <a href="#{@xml:id}">
                                    <xsl:value-of select="tei:head[not(@type)]"/>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                </nav>
                <!-- <div id="viewer">
                    <xsl:for-each select="//tei:surface">
                        <div class="img-container" id="img-{@xml:id}">
                            <img src="{tei:graphic/@url}" style="width: 100%;" />
                            <xsl:for-each select="tei:zone">
                                <div class="highlight-zone" id="zone-{@xml:id}" 
                                     style="left:{@ulx div 22.73}%; top:{@uly div 32.82}%; width:{@lrx div 22.73 - @ulx div 22.73}%; height:{@lry div 32.82 - @uly div 32.82}%;">
                                </div>
                            </xsl:for-each>
                        </div>
                    </xsl:for-each>
                </div> -->

                 <div id="text-content">
                    <xsl:apply-templates select="//tei:body"/>
                </div>
<!--
                <script>
                    function highlight(id, action) {
                        const zoneIds = id.replace('#', '').split(' ');
                        zoneIds.forEach(zId => {
                            const el = document.getElementById('zone-' + zId);
                            if (el) action === 'on' ? el.classList.add('active-zone') : el.classList.remove('active-zone');
                        });
                    }
                </script> -->
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:body">
        <xsl:apply-templates select="tei:div[@type='article' or @type='bibliography' or @type='section']"/>
    </xsl:template>

    <xsl:template match="tei:div">
        <article id="{@xml:id}">
            <xsl:apply-templates />
        </article>
    </xsl:template>

    <xsl:template match="tei:head">
        <xsl:variable name="facs" select="translate(@facs, '#', '')"/>
        <div class="titolo_articolo" data-facs="{$facs}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:p">
        <xsl:variable name="facs" select="translate(@facs, '#', '')"/>
        <div class="paragrafo" data-facs="{$facs}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>

     <xsl:template match="tei:pb">
        <div class="page-break">Pagina <xsl:value-of select="@n"/></div>
    </xsl:template>

    <!-- Valuto se fare il testo diviso in colonne come l'originale -->

    <!-- <xsl:template match="tei:choice">
        <span class="choice-container">
            <span class="orig"><xsl:apply-templates select="tei:orig|tei:abbr" /></span>
            <span class="reg"><xsl:apply-templates select="tei:reg|tei:expan" /></span>
        </span>
    </xsl:template> -->

    <xsl:template match="tei:persName">
        <span class="persName" title="Persona"><xsl:apply-templates /></span>
    </xsl:template>

    <xsl:template match="tei:placeName">
        <span class="placeName" title="Luogo"><xsl:apply-templates /></span>
    </xsl:template>
    

    <xsl:template match="tei:hi[@rend='bold']"><strong><xsl:apply-templates/></strong></xsl:template>
    <xsl:template match="tei:hi[@rend='italic']"><em><xsl:apply-templates/></em></xsl:template>

</xsl:stylesheet>