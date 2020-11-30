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
package org.apache.royale.jewel
{
    import org.apache.royale.core.IMXMLDocument;
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.events.Event;
    import org.apache.royale.jewel.supportClasses.container.ContainerBase;
    import org.apache.royale.utils.MXMLDataInterpreter;
	
	/**
	 * The default property uses when additional MXML content appears within an element's
	 * definition in an MXML file.
	 */
	[DefaultProperty("mxmlContent")]
	
    /**
     *  The Jewel Container class is a container that adds up to the features
	 *  already provided by Jewel Group.
	 *  
	 *  The position and size of the children are determined by BasicLayout 
	 *  while the size of a Container can either be determined by its children or by
     *  specifying an exact size in pixels or as a percentage of the parent element.
	 *  You can swap the layout for any other one available making children arrange
	 *  in different ways (i.e: horizontal, vertical,...)
     *
     *  Container clip content by default thanks to its Viewport bead. This bead can 
	 *  also manage clipping trough `clipContent` property. To add scrolling functionality
	 *  Viewport bead can be changed by ScrollingViewport.
	 *  
	 *  Other Group feature are "View States" to provide state management to show diferent
	 *  parts to the user.
	 *  
	 *  Finally Container can add elements directly to the strand (throught `strandChildren` 
	 *  property) instead to its view content unlike the `addElement()` APIs which place
	 *  children into the contentView.
	 *   
     *  While the container is relatively lightweight, it should
     *  generally not be used as the base class for other controls,
     *  even if those controls are composed of children.  That's
     *  because the fundamental API of Container is to support
     *  an arbitrary set of children, and most controls only
     *  support a specific set of children.
     *  
     * @toplevel
     *  @see org.apache.royale.jewel.beads.layout
     *  @see org.apache.royale.jewel.supportClasses.Viewport
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */    
	public class Container extends ContainerBase implements IMXMLDocument
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function Container()
		{
			super();
			typeNames = "jewel container";
		}

		private var _mxmlDescriptor:Array;
		private var _mxmlDocument:Object = this;
		private var _initialized:Boolean;
		
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
			
			if (!_initialized)
			{
				MXMLDataInterpreter.generateMXMLInstances(_mxmlDocument, this, MXMLDescriptor);
				
				dispatchEvent(new Event("initBindings"));
				dispatchEvent(new Event("initComplete"));
				_initialized = true;
			}
		}
		
		/**
		 *  @copy org.apache.royale.core.Application#MXMLDescriptor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
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
		 *  @productversion Royale 0.9.4
		 */
		public function generateMXMLAttributes(data:Array):void
		{
			MXMLDataInterpreter.generateMXMLProperties(this, data);
		}
		
		/**
		 *  The array of childs for this group. Is the `DefaultProperty`.
		 *  
		 *  @copy org.apache.royale.core.ItemRendererClassFactory#mxmlContent
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
         * 
         *  @royalesuppresspublicvarwarning
		 */
		public var mxmlContent:Array;
	}
}
