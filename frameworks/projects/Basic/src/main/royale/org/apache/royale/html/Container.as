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
	import org.apache.royale.core.ContainerBase;
	import org.apache.royale.core.IMXMLDocument;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.utils.MXMLDataInterpreter;
	
	/**
	 * The default property uses when additional MXML content appears within an element's
	 * definition in an MXML file.
	 */
	[DefaultProperty("mxmlContent")]

	
    /**
     *  The Container class implements a basic container for
     *  other controls and containers.  The position and size
     *  of the children are determined by a layout while the size of
     *  a Container can either be determined by its children or by
     *  specifying an exact size in pixels or as a percentage of the
     *  parent element.
     *
     *  This Container does not have a built-in scroll bar or clipping of
     *  its content should the content exceed the Container's boundaries. To
     *  have scroll bars and clipping, add the ScrollingView bead.  
     * 
     *  While the container is relatively lightweight, it should
     *  generally not be used as the base class for other controls,
     *  even if those controls are composed of children.  That's
     *  because the fundamental API of Container is to support
     *  an arbitrary set of children, and most controls only
     *  support a specific set of children.
     * 
     *  And that's one of the advantages of beads: that functionality
     *  used in a Container can also be used in a Control as long
     *  as that bead doesn't assume that its strand is a Container.
     * 
     *  For example, even though you can use a Panel to create the
     *  equivalent of an Alert control, the Alert is a 
     *  control and not a Container because the Alert does not
     *  support an arbitrary set of children.
     *  
     *  @toplevel
     *  @see org.apache.royale.html.beads.layout
     *  @see org.apache.royale.html.supportClasses.ScrollingViewport
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */    
	public class Container extends ContainerBase implements IMXMLDocument
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function Container()
		{
			COMPILE::JS
			{
				typeNames = 'Container';
			}
			super();
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
				
				//?? why is this here? childrenAdded(); //?? Is this needed since MXMLDataInterpreter will have already called it
			}
		}
		
		/**
		 *  @copy org.apache.royale.core.Application#MXMLDescriptor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
         * 
         *  @royalesuppresspublicvarwarning
		 */
		public var mxmlContent:Array;
	}
}
