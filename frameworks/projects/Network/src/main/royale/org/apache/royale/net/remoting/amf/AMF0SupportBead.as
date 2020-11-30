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
package org.apache.royale.net.remoting.amf
{
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IDocument;

    
    /**
     *  The AMF0SupportBead adds support for legacy AMF0
     *  serialization/deserialization into AMFBinaryData
     *  It should be used once at the Application level
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class AMF0SupportBead implements IBead, IDocument
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function AMF0SupportBead()
		{
		}
		
        private static var _strandSet:Boolean;


        public static function installAMF0Support():void{
            COMPILE::JS{
                AMF0AMF3Context.install();
            }
        }
        
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
            if (!value || _strandSet) return;
            _strandSet = true;
            installAMF0Support();
        }

        /**
         *  the following ensures that this bead will be processed in mxml bead declaration order
         *  @private
         *  @royaleignorecoercion org.apache.royale.core.IStrand
         */
        public function setDocument(document:Object, id:String = null):void
        {
            if (document is IStrand) {
                strand = IStrand(document);
            }
        }
            

    }
}
