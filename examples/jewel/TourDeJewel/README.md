////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

## DESCRIPTION

Tour De Jewel is a Component Explorer for Apache Royale Jewel UI Set.

Jewel is a new UI component set for JavaScript, created with design and
responsiveness in mind.

Apache Royale provides themes to use with Jewel out of the box.  Jewel themes
support up to 12 colors, light/dark, and flat/normal modes.

This App shows all Jewel components and different use cases and is still in
development as we continue make it grow and improve.

This App shows all Jewel components and different use cases and is still in development
as we continue to make it grow and improve.

## Typeface

### **Lato**  
Tour De Jewel uses the Lato typeface, which is loaded dynamically from Google Fonts and is **not distributed** as part of this repository or its binary releases.

You can download it for free from Google Fonts:  
🔗 [Lato on Google Fonts](https://fonts.google.com/specimen/Lato)

This Font Software is licensed under the **SIL Open Font License, Version 1.1**.  
You can find more details about the license and FAQ at:  
🔗 [Open Font License](https://openfontlicense.org)

## External Libraries  

### **Highlight.js**  
Tour De Jewel includes **highlight.js**, a syntax highlighter with language auto-detection, written in JavaScript.  
🔗 [Official website](https://highlightjs.org/)

Highlight.js is licensed under the **BSD-3-Clause License**.  
See our LICENSE file for details:  
🔗 [highlight.js LICENSE](https://github.com/highlightjs/highlight.js/blob/main/LICENSE)

This library is included in our distribution for syntax highlighting.

HOW TO BUILD

For convenience, this example includes build scripts, including a pom.xml file
to build with Maven and a build.xml file to build with Ant.

BUILD WITH MAVEN

To build with Maven, run the following command in the project's root directory
(which should be the same directory that contains this README file):

	mvn compile

The debug version of the app built with Maven can be found in the
./target/javascript/bin/js-debug directory, and the optimized release version of
the app can be found in the ./target/javascript/bin/js-release directory. 

BUILD WITH ANT

To build with Ant, run the following command in this project's root directory
(which should be the same directory that contains this README file):

	ant

The debug version of the app built with Ant can be found in the ./bin/js-debug
directory, and the optimized release version of the app can be found in the
./bin/js-release directory.
