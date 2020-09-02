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
package org.apache.royale.html.supportClasses
{
	import org.apache.royale.core.StyledUIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.utils.MXMLDataInterpreter;
	import org.apache.royale.core.ILabelFieldItemRenderer;
		
	[DefaultProperty("mxmlContent")]

	/**
     *  Indicates that the initialization of the container is complete.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="initComplete", type="org.apache.royale.events.Event")]
	
	/**
	 *  The StyledUIItemRendererBase is an UIItemRendererBase that support the StyledUIBase base class
	 *
 	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class StyledUIItemRendererBase extends StyledUIBase implements ILabelFieldItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function StyledUIItemRendererBase()
		{
		}
		
		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			MXMLDataInterpreter.generateMXMLProperties(this, mxmlProperties);
			MXMLDataInterpreter.generateMXMLInstances(this, this, MXMLDescriptor);
			
			super.addedToParent();
			
			// very common for item renderers to be resized by their containers,
			addEventListener("widthChanged", sizeChangeHandler);
			addEventListener("heightChanged", sizeChangeHandler);
			addEventListener("sizeChanged", sizeChangeHandler);

			// each MXML file can also have styles in fx:Style block
			ValuesManager.valuesImpl.init(this);
			
			dispatchEvent(new Event("initBindings"));
			dispatchEvent(new Event("initComplete"));
		}
		
		/**
		 *  @copy org.apache.royale.core.ItemRendererClassFactory#mxmlContent
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 * 
		 *  @royalesuppresspublicvarwarning
		 */
		public var mxmlContent:Array;
		
		/**
		 * @private
		 */
		public function get MXMLDescriptor():Array
		{
			return null;
		}
		
		private var mxmlProperties:Array ;
		
		/**
		 * @private
		 */
		public function generateMXMLAttributes(data:Array):void
		{
			mxmlProperties = data;
		}
				
		protected var _data:Object;
		
		[Bindable("__NoChangeEvent__")]
		/**
		 *  The data being represented by this itemRenderer. This can be something simple like a String or
		 *  a Number or something very complex.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		private var _labelField:String = "label";
		
		/**
		 * The name of the field within the data to use as a label. Some itemRenderers use this field to
		 * identify the value they should show while other itemRenderers ignore this if they are showing
		 * complex information.
		 */
		public function get labelField():String
		{
			return _labelField;
		}
		public function set labelField(value:String):void
		{
			_labelField = value;
		}
		
		private var _index:int;
		
		/**
		 *  The position with the dataProvider being shown by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get index():int
		{
			return _index;
		}
		public function set index(value:int):void
		{
			_index = value;
		}
				
		/**
		 * @private
		 */
		private function sizeChangeHandler(event:Event):void
		{
			adjustSize();
		}
		
		/**
		 *  This function is called whenever the itemRenderer changes size. Sub-classes should override
		 *  this method an handle the size change.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function adjustSize():void
		{
			// handle in subclass
		}
	}
}
