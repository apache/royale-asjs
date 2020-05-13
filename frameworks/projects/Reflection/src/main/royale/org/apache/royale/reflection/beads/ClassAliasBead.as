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
package org.apache.royale.reflection.beads
{
    COMPILE::SWF
    {
        import flash.net.registerClassAlias;
        import flash.utils.getDefinitionByName;        
    }
    COMPILE::JS
    {
        import org.apache.royale.reflection.registerClassAlias;
        import org.apache.royale.reflection.getDefinitionByName;        
    }
    
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IFlexInfo;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IDocument;
    
    /**
     *  The ClassAliasBead class is the registers class
     *  aliases for serialization/deserialization.
     *  Place this bead in the strand of the Application.
     *  The compiler leaves information about class aliases
     *  on the Application's info object.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ClassAliasBead implements IBead, IDocument
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ClassAliasBead()
		{
		}
		
        private var _strand:IStrand;
        
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @royaleignorecoercion org.apache.royale.core.IFlexInfo
         *  @royaleignorecoercion Class
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function set strand(value:IStrand):void
        {
            if (_strand == value) return;
            _strand = value;
            var app:IFlexInfo = value as IFlexInfo;
            var info:Object = app.info();
            var map:Object = info['remoteClassAliases'];
            if (map)
            {
                for (var cn:String in map)
                {
                    var alias:String = map[cn];
                    var c:Class = getDefinitionByName(cn) as Class;
                    if (c) // if no class, may have only been used in JS as a type and never actually instantiated
                        registerClassAlias(alias, c);
                }
            }
        }

        /**
         *  the following ensures that ClassAliasBead will be processed in mxml bead declaration order,
         *  before other subsequent application beads which can run code that requires class aliases
         *  for example :
         *  a model bead that is set up from its instantiation based on deserialization (using class aliases) of content from local storage
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
