/*
 *
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
 *
 */

import java.io.*
import org.junit.Assert
import org.hamcrest.core.Is
import org.apache.maven.model.io.xpp3.MavenXpp3Reader
import org.apache.maven.model.Model
import java.util.Scanner

// Get the artifactId and version from the pom.
File pom = new File((File) basedir, "pom.xml")
MavenXpp3Reader reader = new MavenXpp3Reader();
Model model = reader.read(new FileReader(pom));
String artifactId = model.artifactId
String version = model.version

// Find the index.html produced by the build
System.out.println("Base Dir: " + ((File) basedir).getPath())
String fileName = "target/" + artifactId + "-" + version + "/index.html"
File file = new File((File) basedir, fileName)

// Check that the index.html file exists and is a file
System.out.println("Template File: " + file.getPath())
Assert.assertThat("Template file doesn't exist", file.exists(), Is.is(true))
Assert.assertThat("Template file isn't a file", file.isFile(), Is.is(true))

// Check that the file contains the additional content from our template
Scanner sc = new Scanner(file)
boolean foundCustomName = false
boolean foundCustomStylesheet = false
while (sc.hasNextLine()) {
    String line = sc.nextLine()
    if(line.contains("<meta name=\"Custom Template for injecting custom style CSS\">")) {
        foundCustomName = true
    } else if(line.contains("<link rel=\"stylesheet\" type=\"text/css\" href=\"my-custom-style.css\">")) {
        foundCustomStylesheet = true
    }
    if(foundCustomName && foundCustomStylesheet) {
        break
    }
}
Assert.assertThat("Output should contain '<meta name=\"Custom Template for injecting custom style CSS\">'",
        foundCustomName, Is.is(true))
Assert.assertThat("Output should contain '<link rel=\"stylesheet\" type=\"text/css\" href=\"my-custom-style.css\">'",
        foundCustomStylesheet, Is.is(true))
