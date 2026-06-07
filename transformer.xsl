<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes" />

    <xsl:param name="mode" select="'original'" />

    <xsl:template match="/">
        <html>
            <head>
                <title><xsl:value-of select="//tei:titleStmt/tei:title"/></title>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <meta name="description" content="{normalize-space(//tei:encodingDesc/tei:projectDesc)}"/>
                <xsl:for-each select="//tei:titleStmt/tei:respStmt/tei:persName">
                    <meta name="author" content="{normalize-space(.)}"/>
                </xsl:for-each>
                <link rel="stylesheet" href="style.css"/>
                
            </head>
            <body>
                <nav id="indice">
                    <h1><xsl:value-of select="//tei:titleStmt/tei:title"/></h1>
                    <ul class="nav-links">
                        <xsl:for-each select="//tei:div[@type='article' or @type='bibliography' or @type='section']">
                            <li>
                                <a href="#{@xml:id}">
                                    <xsl:value-of select="tei:head[not(@type)]"/>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                    
                    <div class="hamburger-menu">
                        <button type="button" id="menu-toggle" class="menu-toggle" aria-label="Apri menu evidenziazioni" aria-expanded="false">
                            <span></span>
                            <span></span>
                            <span></span>
                        </button>

                        <div class="highlight-buttons menu-panel" id="highlight-menu">
                            <button type="button" data-highlight="persName">
                                Persone
                            </button>

                            <button type="button" data-highlight="placeName">
                                Luoghi
                            </button>

                            <button type="button" data-highlight="orgName">
                                Organizzazioni
                            </button>

                            <button type="button" data-highlight="date">
                                Date
                            </button>

                            <button type="button" id="reset-highlights">
                                Rimuovi evidenziazioni
                            </button>
                            <p class="version-switch-title">Versione testo</p>

                            <div class="version-switch-buttons" role="group" aria-label="Seleziona la versione del testo">
                                <button 
                                    type="button" 
                                    class="version-button" 
                                    data-version="diplomatic" 
                                    aria-pressed="true">
                                    Diplomatica
                                </button>

                                <button 
                                    type="button" 
                                    class="version-button" 
                                    data-version="interpretative" 
                                    aria-pressed="false">
                                    Interpretativa
                                </button>
                            </div>
                        </div>
                    </div>
                </nav>

                <div id="image-section">
                    <xsl:apply-templates select="//tei:facsimile/tei:surface"/>
                </div>

                 <div id="text-section">
                    <xsl:apply-templates select="//tei:body"/>
                </div>
                <script src="main.js"></script>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:surface">
        <div class="facsimile-page" id="{@xml:id}">
            <svg class="facsimile-svg" preserveAspectRatio="xMidYMid meet">
                <xsl:attribute name="viewBox">
                    <xsl:text>0 0 </xsl:text>
                    <xsl:value-of select="translate(tei:graphic/@width, 'px', '')"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="translate(tei:graphic/@height, 'px', '')"/>
                </xsl:attribute>

                <image x="0" y="0" preserveAspectRatio="none">
                    <xsl:attribute name="width">
                        <xsl:value-of select="translate(tei:graphic/@width, 'px', '')"/>
                    </xsl:attribute>

                    <xsl:attribute name="height">
                        <xsl:value-of select="translate(tei:graphic/@height, 'px', '')"/>
                    </xsl:attribute>

                    <xsl:attribute name="href">
                        <xsl:value-of select="tei:graphic/@url"/>
                    </xsl:attribute>
                </image>

                <xsl:apply-templates select="tei:zone"/>
            </svg>
        </div>
    </xsl:template>


    <xsl:template match="tei:zone">
        <rect class="facsimile-zone">
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>

            <xsl:attribute name="data-zone">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>

            <xsl:attribute name="x">
                <xsl:value-of select="@ulx"/>
            </xsl:attribute>

            <xsl:attribute name="y">
                <xsl:value-of select="@uly"/>
            </xsl:attribute>

            <xsl:attribute name="width">
                <xsl:value-of select="@lrx - @ulx"/>
            </xsl:attribute>

            <xsl:attribute name="height">
                <xsl:value-of select="@lry - @uly"/>
            </xsl:attribute>
        </rect>
    </xsl:template>

    <xsl:template match="tei:body">
        <xsl:apply-templates select="tei:div[@type='article' or @type='bibliography' or @type='section']"/>
    </xsl:template>

    <xsl:template match="tei:div">
        <article class="articolo" id="{@xml:id}">
            <xsl:apply-templates />
        </article>
    </xsl:template>

    <xsl:template match="tei:head">
        <xsl:choose>
            <xsl:when test="@facs">
                <xsl:variable name="facs" select="translate(@facs, '#', '')"/>
                <xsl:variable name="firstFacs">
                    <xsl:choose>
                        <xsl:when test="contains($facs, ' ')">
                            <xsl:value-of select="substring-before($facs, ' ')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$facs"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <div class="titolo_articolo" id="text-{$firstFacs}" data-facs="{$facs}">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>

            <xsl:otherwise>
                <div class="titolo_articolo">
                    <xsl:apply-templates/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:bibl">
        <xsl:variable name="facs" select="translate(@facs, '#', '')"/>

        <xsl:choose>
            <xsl:when test="@facs">
                <xsl:variable name="firstFacs">
                    <xsl:choose>
                        <xsl:when test="contains($facs, ' ')">
                            <xsl:value-of select="substring-before($facs, ' ')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$facs"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <div class="paragrafo bibl-entry" id="text-{$firstFacs}" data-facs="{$facs}">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>

            <xsl:otherwise>
                <div class="paragrafo bibl-entry">
                    <xsl:apply-templates/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:p">
        <xsl:variable name="facs" select="translate(@facs, '#', '')"/>
        <xsl:variable name="firstFacs">
            <xsl:choose>
                <xsl:when test="contains($facs, ' ')">
                    <xsl:value-of select="substring-before($facs, ' ')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$facs"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <div class="paragrafo" id="text-{$firstFacs}" data-facs="{$facs}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>

     <xsl:template match="tei:pb">
        <div class="page-break"><strong>Pagina <xsl:value-of select="@n"/></strong></div>
    </xsl:template>

    <xsl:template match="tei:choice">
        <span class="choice">
            <xsl:if test="tei:abbr">
                <span class="diplomatic"><xsl:apply-templates select="tei:abbr"/></span>
            </xsl:if>
            <xsl:if test="tei:sic">
                <span class="diplomatic"><xsl:apply-templates select="tei:sic"/></span>
            </xsl:if>
            <xsl:if test="tei:orig">
                <span class="diplomatic"><xsl:apply-templates select="tei:orig"/></span>
            </xsl:if>
            <xsl:if test="tei:expan">
                <span class="interpretative"><xsl:apply-templates select="tei:expan"/></span>
            </xsl:if>
            <xsl:if test="tei:corr">
                <span class="interpretative"><xsl:apply-templates select="tei:corr"/></span>
            </xsl:if>
            <xsl:if test="tei:reg">
                <span class="interpretative"><xsl:apply-templates select="tei:reg"/></span>
            </xsl:if>
        </span>
    </xsl:template>

    <xsl:template match="tei:persName">
        <span class="persName"><xsl:apply-templates /></span>
    </xsl:template>

    <xsl:template match="tei:placeName">
        <span class="placeName"><xsl:apply-templates /></span>
    </xsl:template>
    
    <xsl:template match="tei:orgName">
        <span class="orgName"><xsl:apply-templates/></span>
    </xsl:template>

    <xsl:template match="tei:date">
        <span class="date"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="tei:note">
        <xsl:choose>
            <xsl:when test="@place = 'foot'">
                <div class="footnote">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>

            <xsl:otherwise>
                <span class="note">
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:term">
        <xsl:variable name="reference" select="translate(@ref, '#', '')"/>
        <xsl:variable name="gloss" select="//tei:gloss[@xml:id = $reference]"/>

        <xsl:choose>
            <xsl:when test="$gloss">
                <span class="term" data-id="{$reference}">
                    <xsl:apply-templates/>

                    <span class="term_content">
                        <xsl:value-of select="$gloss"/>
                    </span>
                </span>
            </xsl:when>

            <xsl:otherwise>
                <span class="term" title="{@type}">
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:distinct">
        <xsl:variable name="reference" select="translate(@corresp, '#', '')"/>
        <xsl:variable name="gloss" select="//tei:gloss[@xml:id = $reference]"/>

        <xsl:choose>
            <xsl:when test="$gloss">
                <span class="distinct" data-id="{$reference}">
                    <xsl:apply-templates/>

                    <span class="distinct_content">
                        <xsl:value-of select="$gloss"/>
                    </span>
                </span>
            </xsl:when>

            <xsl:otherwise>
                <span class="distinct" title="{@type}">
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[@rend='bold']">
        <strong>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>

    <xsl:template match="*[@rend='italic']">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>

    <xsl:template match="tei:space">
        <span style="width: 10em;">
        </span>
        <xsl:apply-templates/>

    </xsl:template>

</xsl:stylesheet>