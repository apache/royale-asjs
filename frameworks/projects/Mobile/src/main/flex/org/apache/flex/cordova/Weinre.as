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
package org.apache.royale.cordova
{
    COMPILE::SWF
    {
        import flash.net.URLRequest;
        import flash.net.navigateToURL;            
    }
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	
	/**
	 *  A class that helps set up to use Weinre for debugging
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class Weinre implements IBead
	{
		public function Weinre()
		{
		}

		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
		/**
		 *  The guid to use at the Weinre server
		 *  http://debug.phonegap.com
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         *  @royaleignorecoercion HTMLScriptElement
         *  @royaleignorecoercion HTMLHeadElement
		 */
		public function set guid(value:String):void
		{
            COMPILE::SWF
            {
                navigateToURL(new URLRequest("http://debug.phonegap.com/client/#" + value), "_blank");                    
            }
            COMPILE::JS
            {
                var scriptNode:HTMLScriptElement = document.createElement('SCRIPT') as HTMLScriptElement;
                scriptNode.type = 'text/javascript';
                scriptNode.src = 'http://debug.phonegap.com/target/target-script-min.js#' + value;
                
                var headNode:HTMLHeadElement = document.getElementsByTagName('HEAD') as HTMLHeadElement;
                if (headNode[0] != null)
                    headNode[0].appendChild(scriptNode);
            }
		}
	}
}
