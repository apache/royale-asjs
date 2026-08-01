<?xml version="1.0" encoding="UTF-8"?>
<!--

  Licensed to the Apache Software Foundation (ASF) under one
  or more contributor license agreements.  See the NOTICE file
  distributed with this work for additional information
  regarding copyright ownership.  The ASF licenses this file
  to You under the Apache License, Version 2.0 (the
  "License"); you may not use this file except in compliance
  with the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing,
  software distributed under the License is distributed on an
  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  KIND, either express or implied.  See the License for the
  specific language governing permissions and limitations
  under the License.

-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://maven.apache.org/POM/4.0.0"
    exclude-result-prefixes="m">

    <xsl:output method="text" encoding="UTF-8"/>

    <xsl:template match="/m:project">
        <xsl:for-each select="m:modules/m:module">
            <xsl:variable name="module" select="string(.)"/>
            <xsl:variable name="project" select="document(concat($module, '/pom.xml'), /)/m:project"/>
            <xsl:text>MODULE&#9;</xsl:text>
            <xsl:value-of select="$module"/>
            <xsl:text>&#9;</xsl:text>
            <xsl:value-of select="$project/m:parent/m:groupId"/>
            <xsl:text>&#9;</xsl:text>
            <xsl:value-of select="$project/m:artifactId"/>
            <xsl:text>&#9;</xsl:text>
            <xsl:value-of select="$project/m:version"/>
            <xsl:text>&#10;</xsl:text>

            <xsl:for-each select="$project/m:dependencies/m:dependency | $project/m:profiles/m:profile/m:dependencies/m:dependency">
                <xsl:text>DEPENDENCY&#9;</xsl:text>
                <xsl:value-of select="$module"/>
                <xsl:text>&#9;</xsl:text>
                <xsl:value-of select="m:classifier"/>
                <xsl:text>&#9;</xsl:text>
                <xsl:value-of select="m:groupId"/>
                <xsl:text>&#9;</xsl:text>
                <xsl:value-of select="m:artifactId"/>
                <xsl:text>&#9;</xsl:text>
                <xsl:value-of select="m:version"/>
                <xsl:text>&#10;</xsl:text>
            </xsl:for-each>

            <xsl:for-each select="$project/m:build/m:plugins/m:plugin[m:artifactId = 'royale-maven-plugin']/m:configuration/m:namespaces/m:namespace">
                <xsl:variable name="namespaceType" select="m:type"/>
                <xsl:variable name="uri" select="m:uri"/>
                <xsl:variable name="manifestPath" select="substring-after(m:manifest, '${project.basedir}/')"/>
                <xsl:text>NAMESPACE&#9;</xsl:text>
                <xsl:value-of select="$module"/>
                <xsl:text>&#9;</xsl:text>
                <xsl:value-of select="$namespaceType"/>
                <xsl:text>&#9;</xsl:text>
                <xsl:value-of select="$uri"/>
                <xsl:text>&#9;</xsl:text>
                <xsl:value-of select="$manifestPath"/>
                <xsl:text>&#10;</xsl:text>
                <xsl:for-each select="document($manifestPath, $project)/*/component">
                    <xsl:text>TAG&#9;</xsl:text>
                    <xsl:value-of select="$module"/>
                    <xsl:text>&#9;</xsl:text>
                    <xsl:value-of select="$namespaceType"/>
                    <xsl:text>&#9;</xsl:text>
                    <xsl:value-of select="$uri"/>
                    <xsl:text>&#9;</xsl:text>
                    <xsl:value-of select="@id"/>
                    <xsl:text>&#9;</xsl:text>
                    <xsl:value-of select="@class"/>
                    <xsl:text>&#9;</xsl:text>
                    <xsl:value-of select="@lookupOnly"/>
                    <xsl:text>&#10;</xsl:text>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>