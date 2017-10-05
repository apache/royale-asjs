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
package org.apache.royale.core
{   
    import flash.display.DisplayObjectContainer;
    import flash.text.Font;
    
    import org.apache.royale.core.IStyleableObject;
    import org.apache.royale.events.Event;
		
    /**
     *  The StyleableCSSTextField class implements more CSS text styles in a TextField.
     *  This makes it easier to use one in a "shadow DOM" in a complex skin.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    COMPILE::SWF
	public class StyleableCSSTextField extends CSSTextField implements IStyleableObject
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function StyleableCSSTextField()
		{
			super();
            // this is the object passed into CSS lookups since it can
            // have its own individual styles and isn't subordinate
            // to a parent.
            styleParent = this;
		}
		
        /**
         *  @private
         *  The CSSParent property is set if the CSSTextField
         *  is used in a SimpleButton-based instance because
         *  the parent property is null, defeating CSS lookup.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var CSSParent:Object;
        
        override public function get parent():DisplayObjectContainer
        {
            if (CSSParent)
                return CSSParent as DisplayObjectContainer;
            
            return super.parent;
        }
        
        private var _id:String;
        
        /**
         *  An id property for MXML documents.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get id():String
        {
            return _id;
        }
        
        /**
         *  @private
         */
        public function set id(value:String):void
        {
            if (_id != value)
            {
                _id = value;
                dispatchEvent(new Event("idChanged"));
            }
        }
        
        private var _styles:Object;
        
        /**
         *  The object that contains
         *  "styles" and other associated
         *  name-value pairs.  You can
         *  also specify a string in
         *  HTML style attribute format.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get style():Object
        {
            return _styles;
        }
        
        /**
         *  @private
         */
        public function set style(value:Object):void
        {
            if (_styles != value)
            {
                if (value is String)
                {
                    _styles = ValuesManager.valuesImpl.parseStyles(value as String);
                }
                else
                    _styles = value;
                dispatchEvent(new Event("stylesChanged"));
            }
        }
        
        /**
         *  A list of type names.  Often used for CSS
         *  type selector lookups.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var typeNames:String;
        
        private var _className:String;
        
        /**
         *  The classname.  Often used for CSS
         *  class selector lookups.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get className():String
        {
            return _className;
        }
        
        /**
         *  @private
         */
        public function set className(value:String):void
        {
            if (_className != value)
            {
                _className = value;
                dispatchEvent(new Event("classNameChanged"));
            }
        }
                
        /**
         *  @private
         */
		override public function set text(value:String):void
		{
            super.text = value;
			var font:String = ValuesManager.valuesImpl.getValue(this, "fontFamily") as String;
            var embeddedFonts:Array = Font.enumerateFonts();
            if (embeddedFonts.length)
                embedFonts = isEmbedded(embeddedFonts, font);
		}
                
        private function isEmbedded(list:Array, name:String):Boolean
        {
            for each (var f:Font in list)
            {
                if (f.fontName == name)
                    return true;
            }
            return false;
        }
	}
}
