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
package
{
    /**
    *  @private
    *  This class is used to link additional classes into Network.swc
    *  beyond those that are found by dependency analysis starting
    *  from the classes specified in manifest.xml.
    */
    internal class NetworkClasses
    {
        import org.apache.royale.net.URLLoader; URLLoader;
        import org.apache.royale.net.URLBinaryLoader; URLBinaryLoader;
        import org.apache.royale.net.HTTPConstants; HTTPConstants;
        import org.apache.royale.net.URLBinaryUploader; URLBinaryUploader;
        import org.apache.royale.net.URLVariables; URLVariables;
        import org.apache.royale.net.events.ResultEvent; ResultEvent;
        import org.apache.royale.net.events.FaultEvent; FaultEvent;
        
        import org.apache.royale.net.remoting.messages.AcknowledgeMessage; AcknowledgeMessage;
        // import org.apache.royale.net.remoting.messages.AcknowledgeMessageExt;
        import org.apache.royale.net.remoting.messages.AsyncMessage; AsyncMessage;
        // import org.apache.royale.net.remoting.messages.AsyncMessageExt;
        import org.apache.royale.net.remoting.messages.CommandMessage; CommandMessage;
        // import org.apache.royale.net.remoting.messages.CommandMessageExt;
        import org.apache.royale.net.remoting.messages.RemotingMessage; RemotingMessage;

        import org.apache.royale.net.remoting.messages.RoyaleClient; RoyaleClient;
	
		import org.apache.royale.net.remoting.amf.AMFBinaryData; AMFBinaryData;
        
        // import org.apache.royale.reflection.registerClassAlias;
        // //RpcClassAliasInitializer
        // registerClassAlias("DSK", AcknowledgeMessageExt);
        // registerClassAlias("DSA", AsyncMessageExt);
        // registerClassAlias("DSC", CommandMessageExt);
        
    }
}

