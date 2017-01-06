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
package org.apache.flex.binding
{
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IDocument;

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
     *  @productversion FlexJS 0.0
     */
	public class ConstantBinding implements IBead, IDocument
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function ConstantBinding()
		{
		}
		
        /**
         *  The source object who's property has the value we want.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
         *  @productversion FlexJS 0.0
         */
		protected var document:Object;

        /**
         *  The destination object.  It is always the same
         *  as the strand.  ConstantBindings are attached to
         *  the strand of the destination object.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var destination:Object;

        /**
         *  If not null, the id of the mxml tag who's property
         *  is being watched for changes.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var sourceID:String;

        /**
         *  If not null, the name of a property on the
         *  mxml document that is being watched for changes.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var sourcePropertyName:String;

        /**
         *  The name of the property on the strand that
         *  is set when the source property changes.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var destinationPropertyName:String;
		
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function set strand(value:IStrand):void
		{
            var val:* = null;
            var objectFromWindow:Object = null;

            if (destination == null)
                destination = value;
            
            if (sourceID != null)
            {
                source = document[sourceID];
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
                    var cname:Object = source.FLEXJS_CLASS_INFO;
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
         *  @copy org.apache.flex.core.IDocument#setDocument()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
