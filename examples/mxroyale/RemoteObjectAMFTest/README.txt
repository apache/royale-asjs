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

DESCRIPTION

See https://github.com/apache/royale-asjs/wiki/Apache-Royale-communication-with-AMF-and-RemoteObject
for more information


AMF is a great way to send data between an Apache Royale client and a backend server. The server could be written in Java, PHP, .NET, Ruby, Python and many other backend technologies.

Read more about AMF here :https://en.wikipedia.org/wiki/Action_Message_Format

Apache Royale supports AMF protocol and to demonstrate it we provide two projects:

RemoteObjectAMFTest: (client implementation)
Is the Apache Royale Client that uses RemoteObject to communicate with the backend server to send and receive data via AMF.Direct Link to this project

SampleAmfWebApp: (server implementation)
Is a Java WebApp that uses Apache Flex BlazeDS to expose some data and objects through an AMF endpoint. Direct Link to this project

To run this example localy you can follow this steps.
Note: At this time some parts of the example only can be build with maven, we'll be providing at some time ANT build, but this is not priority. If you're interested in ANT build you can submit a PR)

1. Build RemoteObjectAMFTest with maven using "mvn clean install". This generates the Apache Royale client.
(this project)

2. Build SampleAmfWebApp with maven using "mvn clean install". This generates the Java Web App with AMF support and will overlay the RemoteObjectAMFTest client compiled in the previous step
(currently in the examples/amf folder)

3. Launch SampleAmfWebApp in the embedded Jetty web server with "java -jar target/SampleAmfWebApp-0.9.6-SNAPSHOT-exec.war". You should be in root SampleAmfWebApp folder. Notice: that SNAPSHOT number is just an example and can be different

4. In a browser launch "http://localhost:8080" and try the examples.
