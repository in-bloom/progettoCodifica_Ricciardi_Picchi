<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                version="1.0">

    <xsl:output method="html" encoding="UTF-8" indent="yes" />
    <xsl:param name="mostraIndice" select="'si'" />
    <xsl:param name="coloreTitolo" select="'blue'" />

    <xsl:template match="/">
        <html>
            <head>
                <xsl:variable name="titoloDocumento"
                              select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title" />

                <title>
                    <xsl:value-of select="$titoloDocumento" />
                </title>

                <link rel="stylesheet" type="text/css" href="./mycss.css" />

                <style>
                    h1{
                        color:<xsl:value-of select="$coloreTitolo" />;
                    }
                </style>
            </head>

            <body>
                <xsl:if test="$mostraIndice = 'si'">
                    <div class="index">
                        <h1>INDEX</h1>
                        <ul>
                            <xsl:apply-templates select="//tei:div[@type='chapter']" mode="index" />
                        </ul>
                    </div>
                </xsl:if>

                <div>
                    <xsl:call-template name="mostraIdentificativo" />
                    <xsl:apply-templates select="child::node()" />
                </div>

            </body>
        </html>
    </xsl:template>
    <xsl:template name="mostraIdentificativo">
        <p>
            <span>
                [identificativo del documento:
                <xsl:value-of select="/tei:TEI/@xml:id" />
                ]
            </span>
        </p>
    </xsl:template>

    <xsl:template match="tei:div" mode="index">
        <ul>
            <xsl:for-each select=".">
                <li>
                    <xsl:value-of select="tei:head" />
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>

    <xsl:template match="tei:titleStmt/tei:title">
        <h2>
            <xsl:value-of select="." />
        </h2>
    </xsl:template>

    <xsl:template match="tei:div/tei:head">
        <h3>
            <xsl:value-of select="." />
        </h3>
    </xsl:template>

    <xsl:template match="tei:persName">
        <a href="http://">
            <xsl:value-of select="current()/text()" />
        </a>
    </xsl:template>

    <xsl:template match="tei:teiHeader">
        <span>
            [identificativo del documento:
            <xsl:value-of select="@xml:id" />
            ]
        </span>
    </xsl:template>

</xsl:stylesheet>