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

                <div id="image-section">
                    <xsl:apply-templates select="//tei:facsimile/tei:surface"/>
                </div>

                 <div id="text-section">
                    <xsl:apply-templates select="//tei:body"/>
                </div>
            </body>
        </html>
    </xsl:template>

    <!-- Inserire facsimile, trasforma le zone in dei rettangoli. Prima vanno aggiustati con ZoneRW -->

    <xsl:template match="tei:body">
        <xsl:apply-templates select="tei:div[@type='article' or @type='bibliography' or @type='section']"/>
    </xsl:template>

    <xsl:template match="tei:div">
        <article class="articolo" id="{@xml:id}">
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
        <span class="persName" title="Persona"><xsl:apply-templates /></span>
    </xsl:template>

    <xsl:template match="tei:placeName">
        <span class="placeName" title="Luogo"><xsl:apply-templates /></span>
    </xsl:template>
    
    <xsl:template match="tei:orgName">
        <span class="orgName" title="Organizzazione"><xsl:apply-templates/></span>
    </xsl:template>

    <xsl:template match="tei:date">
        <span class="date" title="Data"><xsl:apply-templates/></span>
    </xsl:template>

    <xsl:template match="tei:distinct | tei:term">
        <span class="term" data-id="{@xml:id}">
            <xsl:apply-templates/>
            <span class="term_content">
                <xsl:value-of
                    select="//tei:gloss[@target = concat('#', current()/@xml:id)]"/>
            </span>
        </span>
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

</xsl:stylesheet>