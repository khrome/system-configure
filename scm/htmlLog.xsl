<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="no"/>
	<xsl:variable name="roseHost">10.7.2.50</xsl:variable>
	<xsl:template match="log">
		<html>
			<head>
			 	<title>Log</title>
			 	<style>
			 		td { vertical-align: top }
			 		.message { white-space: pre }
			 		.file-list { 
			 			white-space: pre;
			 			font-size:smaller;
			 		}
		 		</style>
		 		<script>
			 		function toggle(id) {
			 			var elem = document.getElementById(id);
			 			if(elem.style.display=='none')
				 			elem.style.display='block';
				 		else
				 			elem.style.display='none';
			 		}
		 		</script>
		 		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
			 </head>
			 <body>
				 <h1>ChangeLog</h1>
				 Revisions: <xsl:value-of select="logentry/@revision"/> - <xsl:value-of select="logentry[last()]/@revision"/><br/>
				 Dates: <xsl:value-of select="substring(logentry/date,0,11)"/> - <xsl:value-of select="substring(logentry[last()]/date,0,11)"/><br/>
				 <br/>
				 <table border="1">
					 <tr>
					 	<th>Rev.</th>
					 	<th width="80">Date</th>
					 	<th>Author</th>
					 	<th>Message</th>	 	 
				 	 </tr>
				 	 <!-- [not(starts-with(translate(message,'csr','CSR'),'[CSR]'))] -->
					 <xsl:apply-templates select="logentry"/>
				 </table>
			 </body>
		</html>
	</xsl:template>
	
	<xsl:template match="logentry">
		<tr style="background-color: #dddddd">
			<xsl:if test="substring(date,10,1) mod 2 = 0">
				<xsl:attribute name="style">background-color: #efefef</xsl:attribute>
			</xsl:if>
			<td><xsl:apply-templates select="@revision"/></td>
			<td><xsl:value-of select="substring(date,0,11)"/></td>
			<td><xsl:apply-templates select="author"/></td>
			<td>
				<div>
					<xsl:apply-templates select="msg"/>
					[<a href="javascript:toggle('{generate-id(paths)}')">...</a>]
				</div>
				<xsl:apply-templates select="paths"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="br"><xsl:copy/></xsl:template>
	<xsl:template match="entityId">
		<xsl:value-of select="."/>(&#8594;
		<a href="http://{$roseHost}/cqweb/main?command=GenerateMainFrame&amp;service=CQ&amp;schema=2003.06.00&amp;contextid=PFpro&amp;entityID={.}&amp;entityDefName=Zadanie"
			target="rose">
			Zadanie
		</a>
		&#8594;
		<a href="http://{$roseHost}/cqweb/main?command=GenerateMainFrame&amp;service=CQ&amp;schema=2003.06.00&amp;contextid=PFpro&amp;entityID={.}&amp;entityDefName=Blad"
			target="rose">
			Błąd
		</a>
		)
	</xsl:template>

	<xsl:template match="paths">
		<code id="{generate-id(.)}" class="file-list"
			style="display: none"><xsl:apply-templates select="path"/></code>
	</xsl:template>

	<xsl:template match="path[@action='A']">
		<font color="green">
			<xsl:apply-templates select="." mode="content"/>
		</font>
	</xsl:template>
	<xsl:template match="path[@action='M']">
		<font color="blue">
			<xsl:apply-templates select="." mode="content"/>
		</font>
	</xsl:template>
	<xsl:template match="path[@action='D']">
		<font color="red">
			<xsl:apply-templates select="." mode="content"/>
		</font>
	</xsl:template>
	
	<xsl:template match="path" mode="content">		
		<xsl:value-of select="@action"/> <xsl:value-of select="text()"/><br/>
	</xsl:template>
</xsl:stylesheet>
