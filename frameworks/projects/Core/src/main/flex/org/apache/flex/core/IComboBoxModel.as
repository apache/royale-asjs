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
	import org.apache.royale.events.IEventDispatcher;
	
    /**
     *  The IComboBoxModel interface describes the minimum set of properties
     *  available to a ComboBox control.  More sophisticated ComboBox controls
     *  could have models that extend IComboBoxModel.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public interface IComboBoxModel extends IEventDispatcher, IBeadModel
	{
        // TODO: should extend ITextModel
        /**
         *  The text displayed in the ComboBox.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get text():String;
		function set text(value:String):void;
		
        /**
         *  The html formatted text displayed in the ComboBox.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get html():String;
		function set html(value:String):void;
		
        /**
         *  The set of choices displayed in the ComboBox's
         *  dropdown.  The dataProvider can be a simple 
         *  array or vector if the set of choices is not
         *  going to be modified (except by wholesale
         *  replacement of the dataProvider).  To use
         *  different kinds of data sets, you may need to
         *  provide an alternate "mapping" bead that
         *  iterates the dataProvider, generates item
         *  renderers and assigns a data item to the
         *  item renderers.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get dataProvider():Object;
		function set dataProvider(value:Object):void;
		
        /**
         *  The index of the selected item in the
         *  dataProvider.  Values less than 0 can
         *  have specific meanings but generally mean
         *  that no item is selected because the
         *  user has typed in a custom entry or has
         *  yet to make a choice.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get selectedIndex():int;
		function set selectedIndex(value:int):void;
		
        /**
         *  The data item selected in the
         *  dataProvider.  null usually means
         *  that the user has not selected a value
         *  and has typed in a custom entry.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get selectedItem():Object;
		function set selectedItem(value:Object):void;
	}
}
