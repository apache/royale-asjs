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
package org.apache.royale.binding
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IDocument;
    import org.apache.royale.core.IBinding;

    COMPILE::SWF
    {
        import flash.utils.getDefinitionByName;
    }
    /**
     *  The ConstantBinding class is lightweight data-binding class that
     *  is optimized for simple assignments of one object's constant to
     *  another object's property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ConstantBinding implements IBead, IDocument, IBinding
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ConstantBinding()
		{
		}

        private var _destination:Object;
        private var _sourceID:String;
        private var _destinationPropertyName:String;
        private var _sourcePropertyName:String;

        /**
         *  The source object who's property has the value we want.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		protected var source:Object;

        /**
         *  The host mxml document for the source and
         *  destination objects.  The source object
         *  is either this document for simple bindings
         *  like {foo} where foo is a property on
         *  the mxml documnet, or found as document[sourceID]
         *  for simple bindings like {someid.someproperty}
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		protected var document:Object;

        /**
         *  @copy org.apache.royale.core.IBinding#destination;
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get destination():Object
        {
            return _destination;
        }

        public function set destination(value:Object):void
        {
            _destination = value;
        }

        /**
         *  @copy org.apache.royale.core.IBinding#sourceID
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get sourceID():String
        {
            return _sourceID;
        }

        public function set sourceID(value:String):void
        {
            _sourceID = value;
        }

        /**
         *  @copy org.apache.royale.core.IBinding#destinationPropertyName
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get destinationPropertyName():String
        {
            return _destinationPropertyName;
        }

        public function set destinationPropertyName(value:String):void
        {
            _destinationPropertyName = value;
        }

        /**
         *  @copy org.apache.royale.core.IBinding#sourcePropertyName
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get sourcePropertyName():String
        {
            return _sourcePropertyName;
        }

        public function set sourcePropertyName(value:String):void
        {
            _sourcePropertyName = value;
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
            var val:* = null;
            var objectFromWindow:Object = null;

            if (destination == null)
                destination = value;
            
            if (sourceID != null)
            {
                COMPILE::SWF{
                    if (sourceID in document)
                        source = document[sourceID];
                }
                COMPILE::JS{
                    source = document[sourceID];
                }
            }
            else
            {
                source = document;
            }

            if (!source)
            {
                try
                {
                    COMPILE::SWF
                    {
                        var classFromSourceId:Class = getDefinitionByName(sourceID) as Class;
                        if (classFromSourceId)
                        {
                            val = classFromSourceId[sourcePropertyName];
                        }
                    }

                    COMPILE::JS
                    {
                        objectFromWindow = getObjectClassFromWindow(sourceID);
                        if (objectFromWindow)
                        {
                            val = objectFromWindow[sourcePropertyName];
                        }
                    }
                    destination[destinationPropertyName] = val;
                }
                catch (e:Error)
                {

                }
            }
            else if (sourcePropertyName in source)
            {
                try
                {
                    val = source[sourcePropertyName];
                    destination[destinationPropertyName] = val;
                }
                catch (e:Error)
                {
                }
            }
            else if (sourcePropertyName in source.constructor)
            {
                try
                {
                    val = source.constructor[sourcePropertyName];
                    destination[destinationPropertyName] = val;
                }
                catch (e2:Error)
                {
                }
            }
            else 
            {
                COMPILE::JS
                {
                    // GCC optimizer only puts exported class constants on
                    // Window and not on the class itself (which got renamed)
                    var cname:Object = source.ROYALE_CLASS_INFO;
                    if (cname) 
                    {
                        cname = cname.names[0].qName;
                        objectFromWindow = getObjectClassFromWindow(cname);
                        if (objectFromWindow)
                        {
                            val = objectFromWindow[sourcePropertyName];
                        }
                        destination[destinationPropertyName] = val;
                    }                    
                }
            }

		}
		
        /**
         *  @copy org.apache.royale.core.IDocument#setDocument()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function setDocument(document:Object, id:String = null):void
		{
			this.document = document;
		}

        COMPILE::JS
        private function getObjectClassFromWindow(className:Object):Object
        {
            var windowObject:Object = window;
            var parts:Array = className.split('.');
            var n:int = parts.length;
            if (n == 0)
            {
                return null;
            }

            for (var i:int = 0; i < n; i++) {
                windowObject = windowObject[parts[i]];
            }

            return windowObject;
        }
    }
}
