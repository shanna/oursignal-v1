<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:digg="http://digg.com/docs/diggrss/">
  <xsl:template match="/">
    <rss xmlns:digg="http://digg.com/docs/diggrss/" version="2.0">
      <channel>
        <title>Oursignal Digg Popular RSS</title>
        <description>A Digg popular RSS feed that includes the story source url.</description>
        <link>http://oursignal.com/rss/digg.rss</link>
      </channel>
      <xsl:for-each select="//story">
        <xsl:sort select="@submit_date" data-type="number" order="descending" />
        <xsl:call-template name="item" />
      </xsl:for-each>
    </rss>
  </xsl:template>

  <xsl:template name="item">
    <item>
      <title><xsl:value-of select="title" /></title>
      <link><xsl:value-of select="@href" /></link>
      <description><xsl:value-of select="description" /></description>
      <guid isPermaLink="false"><xsl:value-of select="@href" /></guid>
      <pubDate><xsl:value-of select="@published" /></pubDate>
      <digg:diggCount><xsl:value-of select="@diggs" /></digg:diggCount>
      <digg:category><xsl:value-of select="@topic" /></digg:category>
      <digg:commentCount><xsl:value-of select="@comments" /></digg:commentCount>
      <digg:source><xsl:value-of select="@link" /></digg:source>
    </item>
  </xsl:template>

</xsl:stylesheet>
