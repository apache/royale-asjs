/**
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */


//  This script will be executed upon creating a project from this archetype.
//  https://maven.apache.org/archetype/maven-archetype-plugin/advanced-usage.html
// 
//  It will delete a the associated Crux folders if the value for the "includeCrux" property
//  is set to false.

import java.io.File
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import org.apache.commons.io.FileUtils
 
println "*******************************"
println "  groovy post processing"
println "*******************************"
// println "artifactId: " + artifactId
// println "request: " + request
// println "archetypeArtifactId: " + request.getArchetypeArtifactId()
// println "archetypeGroupId: " + request.getArchetypeGroupId()
// println "archetypeVersion: " + request.getArchetypeVersion()
// println "archetypeName: " + request.getArchetypeName()
// println "artifactId: " + request.getArtifactId()
// println "groupId: " + request.getGroupId()
// println "version: " + request.getVersion()

Properties properties = request.properties
// println "Properties: " + properties
// println "application: " + request.getProperties().getProperty("application")
// println "moduele: " + request.getProperties().getProperty("module")

// Application path
Path appPath = Paths.get(request.outputDirectory, request.artifactId)// + File.separator + properties.get("application"))
println "appPath prop : " + appPath
String includeCrux = properties.get("includeCrux")
println "includeCrux prop : " + includeCrux
 
if (includeCrux.equals("false")) {
    println "Not includin Crux - Deleting Crux files"

    String packageProp = properties.get("package").equals('') ? "" : properties.get("package").replace(".", File.separator) + File.separator;
    //println "package prop : " + packageProp
    Path configPath = appPath.resolve("src" + File.separator + "main" + File.separator + "royale" + File.separator + packageProp + "config")   
    Path eventsPath = appPath.resolve("src" + File.separator + "main" + File.separator + "royale" + File.separator + packageProp + "events")   
    
    //String configurationFile = "Beans.mxml";    
    //Path cxfConfigPath = configPath.resolve(configurationFile)
    //println "cxfConfigPath " + cxfConfigPath  
    //Files.deleteIfExists cxfConfigPath

    FileUtils.deleteDirectory(configPath.toFile());
    FileUtils.deleteDirectory(eventsPath.toFile());
}
println "*******************************"