////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "Licens"); you may not use this file except in compliance with
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
package org.apache.royale.html.beads
{

	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;

	/**
	 *  The ApplicationParametersBead is used to get URL parameter values specified when loading an application.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.2
	 */
    public class ApplicationParametersBead implements IBead
    {
        public function ApplicationParametersBead()
        {
            
        }

		protected var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.2
		 */
		public function set strand(value:IStrand):void
		{	
			_strand = value;
            urlVars = {};
            
            COMPILE::JS
            {
                var query:String = location.search.substring(1);
                if(query)
                {
                    var vars:Array = query.split("&");
                    for (var i:int=0;i<vars.length;i++) {
                        var pair:Array = vars[i].split("=");
                        urlVars[pair[0]] = decodeURIComponent(pair[1]);
                    }
                }
            }

            COMPILE::SWF
            {
                //TODO SWF implementation
            }

		}

        protected var urlVars:Object;

        /**
         *  Returns the value of the specified URL parameter.
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.2
         */
        public function getValue(parameter:String):String
        {
            return urlVars[parameter];
        }

    }
}