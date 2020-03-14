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
package org.apache.royale.html
{
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IContainer;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.ILayoutParent;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IMXMLDocument;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.beads.layouts.HDividedContainerLayout;
	import org.apache.royale.html.beads.models.DividedContainerModel;
	import org.apache.royale.utils.MXMLDataInterpreter;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	
	[Event(name="initComplete", type="org.apache.royale.events.Event")]
	
	[DefaultProperty("mxmlContent")]
	
	/**
	 * The DividedContainer lays out its children (either horizontally or vertically, depending on
	 * which layout is used) separated by dividers. The dividers can be moved to grow and shrink
	 * the children.
	 * 
	 * This is the base class. See HDividedContainer and VDividedContainer for useful implementations.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class DividedContainer extends UIBase implements IContainer, ILayoutParent, ILayoutHost, ILayoutView, IMXMLDocument
	{
		/**
		 * Constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function DividedContainer()
		{
			super();
			typeNames = "DividedContainer";
		}
		
		// DividedContainerLayout takes care of sizing and positioning the children and the
		// the separators. The layout listens to changes to the DividedContainerModel and uses
		// the model to determine the exact size of each child.
		
		// DividedContainerModel contains the identities of the children and the separators as
		// well as the amount to increase or decrease each child. Once the layout completes,
		// the adjustments are reset to zero (their default values). 
		
		// DividedContainerDivider is a control that sits between the children and has a mouse
		// controller (DividedContainerMouseController) that lets the user interact with the
		// DividedContainer. By pressing the mouse down over the separator and moving it, the
		// mouse controller tracks the changes to the mouse position and updates the model
		// which will then trigger a new layout, adjusting the size and position of the
		// children.
		
		/**
		 * @private
		 */
		override public function addedToParent():void
		{			
			if (!_initialized)
			{
				// each MXML file can also have styles in fx:Style block
				ValuesManager.valuesImpl.init(this);
			}
			
			super.addedToParent();
			
			var layoutBead:IBeadLayout = loadBeadFromValuesManager(HDividedContainerLayout, "iBeadLayout", this) as IBeadLayout;
			
			if (!_initialized)
			{
				MXMLDataInterpreter.generateMXMLInstances(_mxmlDocument, this, MXMLDescriptor);
				
				dispatchEvent(new Event("initBindings"));
				dispatchEvent(new Event("initComplete"));
				_initialized = true;
			}
		}
		
		// IMXMLDocument
		
		private var _mxmlDescriptor:Array;
		private var _mxmlDocument:Object = this;
		private var _initialized:Boolean = false;
		
		/**
		 *  @copy org.apache.royale.core.Application#MXMLDescriptor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get MXMLDescriptor():Array
		{
			return _mxmlDescriptor;
		}
		
		/**
		 *  @private
		 */
		public function setMXMLDescriptor(document:Object, value:Array):void
		{
			_mxmlDocument = document;
			_mxmlDescriptor = value;
		}
		
		/**
		 *  @copy org.apache.royale.core.Application#generateMXMLAttributes()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function generateMXMLAttributes(data:Array):void
		{
			MXMLDataInterpreter.generateMXMLProperties(this, data);
		}
		
		/**
		 *  @copy org.apache.royale.core.ItemRendererClassFactory#mxmlContent
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
         * 
         *  @royalesuppresspublicvarwarning
		 */
		public var mxmlContent:Array;
		
		// ILayoutParent
		
		/**
		 * @private
		 */
		public function getLayoutHost():ILayoutHost
		{
			return this;
		}
		
		// ILayoutHost
		
		/**
		 * @private
		 */
		public function get contentView():ILayoutView
		{
			return this;
		}
		
		/**
		 * @private
		 */
		public function beforeLayout():Boolean
		{
			return true;
		}
		
		/**
		 * @private
		 */
		public function afterLayout():void
		{
			// does nothing
		}
		
		// IContainer
		
		/**
		 * @private
		 */
		public function childrenAdded():void
		{
			dispatchEvent(new Event("childrenAdded"));
		}
		
		/**
		 * @private
		 */
		public function get strandChildren():IParent
		{
			return this;
		}
	}
}