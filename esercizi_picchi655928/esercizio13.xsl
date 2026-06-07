<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                version="1.0">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:param name="visualizzaSommario" select="'true'"/>
    <xsl:param name="colorePrincipale" select="'darkred'"/>
    <xsl:param name="titoloIndice" select="'SOMMARIO'"/>

    <xsl:template match="/">
        <html>
            <head>

                <xsl:variable name="titoloPagina"
                              select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>

                <title>
                    <xsl:value-of select="$titoloPagina"/>
                </title>

                <link rel="stylesheet" type="text/css" href="./mycss.css"/>

                <style>
                    h1 {
                        color: <xsl:value-of select="$colorePrincipale"/>;
                    }

                    .scheda-documento {
                        margin-bottom: 1em;
                        font-style: italic;
                    }
                </style>
            </head>

            <body>

                <xsl:if test="$visualizzaSommario = 'true'">
                    <xsl:call-template name="creaSommario"/>
                </xsl:if>

                <div class="contenuto">

                    <xsl:call-template name="infoDocumento"/>

                    <xsl:apply-templates select="tei:TEI"/>
                </div>

            </body>
        </html>
    </xsl:template>

    <xsl:template name="creaSommario">
        <div class="index">
            <h1>
                <xsl:value-of select="$titoloIndice"/>
            </h1>

            <ul>
                <xsl:apply-templates select="//tei:div[@type='chapter']" mode="sommario"/>
            </ul>
        </div>
    </xsl:template>

    <xsl:template name="infoDocumento">

        <xsl:variable name="codiceDocumento" select="/tei:TEI/@xml:id"/>

        <div class="scheda-documento">
            <span>
                Documento:
                <xsl:choose>
                    <xsl:when test="$codiceDocumento">
                        <xsl:value-of select="$codiceDocumento"/>
                    </xsl:when>
                    <xsl:otherwise>
                        identificativo non disponibile
                    </xsl:otherwise>
                </xsl:choose>
            </span>
        </div>
    </xsl:template>

    <xsl:template match="tei:TEI">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:teiHeader">
        <div class="teiHeader">
            <xsl:apply-templates select="tei:fileDesc/tei:titleStmt"/>
        </div>
    </xsl:template>

    <xsl:template match="tei:titleStmt">
        <div class="titleStmt">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:titleStmt/tei:title">
        <h2>
            <xsl:value-of select="."/>
        </h2>
    </xsl:template>

    <xsl:template match="tei:text">
        <main>
            <xsl:apply-templates/>
        </main>
    </xsl:template>

    <xsl:template match="tei:body">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:div" mode="sommario">
        <li>
            <a href="#{@xml:id}">
                <xsl:value-of select="tei:head"/>
            </a>
        </li>
    </xsl:template>

    <xsl:template match="tei:div[@type='chapter']">
        <section class="capitolo" id="{@xml:id}">
            <xsl:apply-templates/>
        </section>
    </xsl:template>

    <xsl:template match="tei:div/tei:head">
        <h3>
            <xsl:value-of select="."/>
        </h3>
    </xsl:template>

    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:persName">
        <span class="persona">
            <a>
                <xsl:attribute name="href">
                    <xsl:text>#</xsl:text>
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>

                <xsl:value-of select="."/>
            </a>
        </span>
    </xsl:template>

</xsl:stylesheet>