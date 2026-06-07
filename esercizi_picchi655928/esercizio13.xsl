<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:variable name="titoloPagina" select="'Esercizio XSLT'"/>

    <xsl:param name="mostraNote" select="'si'"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>
                    <xsl:value-of select="$titoloPagina"/>
                </title>
            </head>

            <body>
                <h1>
                    <xsl:value-of select="$titoloPagina"/>
                </h1>

                <xsl:call-template name="mostra-intestazione">
                    <xsl:with-param name="testo" select="'Documento trasformato con XSLT'"/>
                </xsl:call-template>

                <div>
                    <xsl:apply-templates/>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template name="mostra-intestazione">
        <xsl:param name="testo"/>

        <div class="intestazione">
            <p>
                <xsl:value-of select="$testo"/>
            </p>
        </div>
    </xsl:template>

    <xsl:template match="tei:text">
        <main>
            <xsl:apply-templates/>
        </main>
    </xsl:template>

    <xsl:template match="tei:div">
        <section>
            <xsl:if test="@type">
                <xsl:attribute name="class">
                    <xsl:value-of select="@type"/>
                </xsl:attribute>
            </xsl:if>

            <xsl:apply-templates/>
        </section>
    </xsl:template>

    <xsl:template match="tei:head">
        <h2>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>

    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:name | tei:persName | tei:placeName">
        <span class="nome">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:term">
        <span class="termine">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:note">
        <xsl:if test="$mostraNote = 'si'">
            <span class="nota">
                <xsl:text> [Nota: </xsl:text>
                <xsl:apply-templates/>
                <xsl:text>]</xsl:text>
            </span>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:list">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="tei:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

</xsl:stylesheet>