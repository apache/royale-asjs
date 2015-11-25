<?xml version="1.0" encoding="UTF-8"?>
<!--

  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

-->
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:s="library://ns.adobe.com/flex/spark" xmlns:fx="http://ns.adobe.com/mxml/2009" xmlns="http://www.w3.org/2000/svg">

	<xsl:strip-space elements="s:*" />
	<xsl:output method="xml" encoding="UTF-8" indent="yes" />

	<xsl:template match="/">
		<svg id="button" width="100%" height="100%" version="1.1" >
			<xsl:apply-templates mode="rect" />
			<xsl:apply-templates mode="text" />
		</svg>
	</xsl:template>
	
	<xsl:template match="fx:Script" mode="#all" />
	<xsl:template match="fx:Metadata" mode="#all" />
	
	<xsl:template match="s:states" mode="rect">
			<xsl:for-each select="s:State">
					<xsl:apply-templates mode="rect" />
			</xsl:for-each>
	</xsl:template>

	<xsl:template match="s:Rect|Rect" mode="rect">
		<svg xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.w3.org/2000/svg"
			version="1.1" >
			<xsl:if test="@left">
				<xsl:attribute name="left">
					<xsl:value-of select="@left" />
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@right">
				<xsl:attribute name="right">
					<xsl:value-of select="@right" />
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@top">
				<xsl:attribute name="top">
					<xsl:value-of select="@top" />
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@bottom">
				<xsl:attribute name="bottom">
					<xsl:value-of select="@bottom" />
				</xsl:attribute>
			</xsl:if>
			<defs>
				<xsl:apply-templates mode="defs" />
			</defs>
		<rect >
			<xsl:if test="@id">
				<xsl:attribute name="id">
					<xsl:value-of select="@id" />
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@x">
				<xsl:attribute name="x">
					<xsl:value-of select="@x" />
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@y">
				<xsl:attribute name="y">
					<xsl:value-of select="@y" />
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@width">
				<xsl:attribute name="width">
					<xsl:value-of select="@width" />
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@height">
				<xsl:attribute name="height">
					<xsl:value-of select="@height" />
				</xsl:attribute>
			</xsl:if>

			<xsl:if test="@radiusX">
				<xsl:attribute name="rx">
					<xsl:value-of select="@radiusX" />
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@radiusY">
				<xsl:attribute name="ry">
					<xsl:value-of select="@radiusY" />
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@radiusX and not(@radiusY)">
				<xsl:attribute name="rx">
					<xsl:value-of select="@radiusX" />
				</xsl:attribute>
				<xsl:attribute name="ry">
					<xsl:value-of select="@radiusX" />
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@radiusY and not(@radiusX)">
				<xsl:attribute name="rx">
					<xsl:value-of select="@radiusY" />
				</xsl:attribute>
				<xsl:attribute name="ry">
					<xsl:value-of select="@radiusY" />
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(@width) ">
					<xsl:attribute name="width">100%</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(@height) ">
					<xsl:attribute name="height">100%</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(s:fill) ">
					<xsl:attribute name="fill">none</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates mode="rect" />

		</rect>
</svg>
	</xsl:template>

	<xsl:template match="s:fill" mode="rect">
		<xsl:apply-templates mode="rect" />
	</xsl:template>
	
	<xsl:template match="s:stroke" mode="rect">
		<xsl:apply-templates mode="rect" />
	</xsl:template>

	<xsl:template match="s:SolidColor" mode="rect">
		<xsl:attribute name="style">fill:#<xsl:value-of
			select="substring-after(@color, '0x')" />
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="s:LinearGradient" mode="rect">
		<xsl:attribute name="style">fill:url(#<xsl:value-of
			select="generate-id(.)" />)</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="s:LinearGradientStroke" mode="rect">
		<xsl:attribute name="style">stroke-width:<xsl:value-of select="@weight+1"></xsl:value-of>;stroke:url(#<xsl:value-of
			select="generate-id(.)" />)</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="//s:LinearGradient" mode="defs">
		<linearGradient>
			<xsl:attribute name="id"><xsl:value-of select="generate-id()" /></xsl:attribute>
			<xsl:if test="@rotation">
				<xsl:attribute name="gradientTransform">rotate(<xsl:value-of select="@rotation" />)</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="defs" />
		</linearGradient>
	</xsl:template>
	
		<xsl:template match="//s:LinearGradientStroke" mode="defs">
			<linearGradient>
				<xsl:attribute name="id"><xsl:value-of select="generate-id()" /></xsl:attribute>
				<xsl:if test="@rotation">
					<xsl:attribute name="gradientTransform">rotate(<xsl:value-of select="@rotation" />)</xsl:attribute>
				</xsl:if>				
				<xsl:apply-templates mode="defs" />
			</linearGradient>
	</xsl:template>

	<xsl:template match="//s:GradientEntry" mode="defs">
		<stop>
			<xsl:attribute name="offset">
				<xsl:value-of select="@ratio"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="stop-color">#<xsl:value-of
				select="substring-after(@color, '0x')" />
			</xsl:attribute>
			<xsl:if test="@alpha">
				<xsl:attribute name="stop-opacity">
					<xsl:value-of select="@alpha" />
				</xsl:attribute>
			</xsl:if>

		</stop>
	</xsl:template>
	
<!-- Text -->

	<xsl:template match="s:Label" mode="text" >
	<svg>
		<text>
			<xsl:if test="@id">
				<xsl:attribute name="id">
					<xsl:value-of select="@id" />
				</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="text-anchor">middle</xsl:attribute>
			<xsl:attribute name="pointer-events">none</xsl:attribute>
			<xsl:attribute name="dy">.3em</xsl:attribute>
			<xsl:attribute name="x">50%</xsl:attribute>
			<xsl:attribute name="y">50%</xsl:attribute>Hello</text>
		</svg>	
	</xsl:template>	
	

</xsl:stylesheet>
