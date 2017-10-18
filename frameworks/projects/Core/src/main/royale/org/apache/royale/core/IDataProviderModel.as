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
     *  The IDataProviderModel interface describes the minimum set of properties
     *  available to control that let the user choose within a
     *  set of items in a dataProvider.
	 *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public interface IDataProviderModel extends IEventDispatcher, IBeadModel
	{
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
        
        // TODO: this is probably not needed in a selection model
        //       and should be in a scheme mapper model.
        /**
         *  The property on the data item that the item renderer
         *  should renderer.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get labelField():String;
		function set labelField(value:String):void;
	}
}
