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
    /**
     *  The IContainer interface is used to mark certain components as Containers.
     *  While most components are containers in the sense that they are composited
     *  from a set of child components, the term Container is commonly used in Flex
     *  to denote components that take an arbitrary set or sets of children and do
     *  not try to abstract away that fact. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public interface ITextInput extends IUIBase
	{	
        //----------------------------------
        //  text
        //----------------------------------
        
        /**
         *  Plain text that appears in the control.
         *  Its appearance is determined by the CSS styles of this Label control.
         *
         *  <p>Any HTML tags in the text string are ignored,
         *  and appear as entered in the string.
         *  To display text formatted using HTML tags,
         *  use the <code>htmlText</code> property instead.
         *  If you set the <code>htmlText</code> property,
         *  the HTML replaces any text you had set using this propety, and the
         *  <code>text</code> property returns a plain-text version of the
         *  HTML text, with all HTML tags stripped out. For more information
         *  see the <code>htmlText</code> property.</p>
         *
         *  <p>To include the special characters left angle  bracket (&lt;),
         *  right angle bracket (&gt;), or ampersand (&amp;) in the text,
         *  wrap the text string in the CDATA tag.
         *  Alternatively, you can use HTML character entities for the
         *  special characters, for example, <code>&amp;lt;</code>.</p>
         *
         *  <p>If you try to set this property to <code>null</code>,
         *  it is set, instead, to the empty string.
         *  The <code>text</code> property can temporarily have the value <code>null</code>,
         *  which indicates that the <code>htmlText</code> has been recently set
         *  and the corresponding <code>text</code> value
         *  has not yet been determined.</p>
         *
         *  @default ""
         *  @tiptext Gets or sets the TextInput content
         *  @helpid 3190
         *
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        function get text():String;
        
        /**
         *  @private
         */
        function set text(value:String):void;
	}
}
