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
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://maven.apache.org/POM/4.0.0"
    exclude-result-prefixes="m">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
        <project name="codegraph-modules" default="codegraphs" basedir="..">
            <import file="../codegraphs.xml"/>
            <target name="codegraphs" depends="codegraphs-js,codegraphs-swf"/>
            <target name="codegraphs-js">
                <xsl:attribute name="depends">
                    <xsl:for-each select="m:project/m:modules/m:module">
                        <xsl:if test="position() != 1">,</xsl:if>
                        <xsl:text>codegraph-</xsl:text><xsl:value-of select="."/><xsl:text>-js</xsl:text>
                    </xsl:for-each>
                </xsl:attribute>
            </target>
            <target name="codegraphs-swf" if="env.AIR_HOME">
                <xsl:attribute name="depends">
                    <xsl:for-each select="m:project/m:modules/m:module">
                        <xsl:if test="position() != 1">,</xsl:if>
                        <xsl:text>codegraph-</xsl:text><xsl:value-of select="."/><xsl:text>-swf</xsl:text>
                    </xsl:for-each>
                </xsl:attribute>
            </target>
            <xsl:for-each select="m:project/m:modules/m:module">
                <target name="codegraph-{.}" depends="codegraph-{.}-js,codegraph-{.}-swf"/>
                <target name="codegraph-{.}-js">
                    <xsl:choose>
                        <xsl:when test=". = 'Ace'">
                            <codegraph-js module="{.}" config="ace-config.xml"/>
                        </xsl:when>
                        <xsl:when test=". = 'CreateJS'">
                            <codegraph-js module="{.}" config="createjs-config.xml"/>
                        </xsl:when>
                        <xsl:when test=". = 'JQuery'">
                            <codegraph-js module="{.}" config="jquery-config.xml"/>
                        </xsl:when>
                        <xsl:when test=". = 'MXRoyaleBase' or . = 'MXRoyale'">
                            <codegraph-js module="{.}">
                                <extra-args>
                                    <arg value="-compiler.define+=ROYALE::DISPLAYOBJECT,IUIComponent"/>
                                    <arg value="-compiler.define+=GOOG::DEBUG,goog.DEBUG"/>
                                </extra-args>
                            </codegraph-js>
                        </xsl:when>
                        <xsl:when test=". = 'SparkRoyale'">
                            <codegraph-js module="{.}">
                                <extra-args>
                                    <arg value="-compiler.define+=GOOG::DEBUG,goog.DEBUG"/>
                                </extra-args>
                            </codegraph-js>
                        </xsl:when>
                        <xsl:otherwise>
                            <codegraph-js module="{.}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </target>
                <target name="codegraph-{.}-swf" if="env.AIR_HOME">
                    <xsl:choose>
                        <xsl:when test=". = 'Ace'">
                            <codegraph-swf module="{.}">
                                <extra-args>
                                    <arg value="-compiler.allow-subclass-overrides=true"/>
                                </extra-args>
                            </codegraph-swf>
                        </xsl:when>
                        <xsl:when test=". = 'MXRoyaleBase' or . = 'MXRoyale'">
                            <codegraph-swf module="{.}">
                                <extra-args>
                                    <arg value="-compiler.define+=GOOG::DEBUG,true"/>
                                    <arg value="-compiler.define+=ROYALE::DISPLAYOBJECT,DisplayObject"/>
                                </extra-args>
                            </codegraph-swf>
                        </xsl:when>
                        <xsl:when test=". = 'SparkRoyale'">
                            <codegraph-swf module="{.}">
                                <extra-args>
                                    <arg value="-compiler.define+=GOOG::DEBUG,true"/>
                                </extra-args>
                            </codegraph-swf>
                        </xsl:when>
                        <xsl:otherwise>
                            <codegraph-swf module="{.}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </target>
            </xsl:for-each>
        </project>
    </xsl:template>

</xsl:stylesheet>