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

package flex.display
{
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IFlexJSElement;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;

	COMPILE::SWF
	{
		import flash.display.MovieClip;
	}
	COMPILE::JS
	{
		import flex.display.DisplayObjectContainer;
	}
	
	COMPILE::SWF
	public class MovieClip extends flash.display.MovieClip
	{
		COMPILE::SWF
		private var _model:IBeadModel;
		
		/**
		 *  An IBeadModel that serves as the data model for the component.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		COMPILE::SWF
		public function get model():Object
		{
			if (_model == null)
			{
				// addbead will set _model
				addBead(new (ValuesManager.valuesImpl.getValue(this, "iBeadModel")) as IBead);
			}
			return _model;
		}
		
		/**
		 *  @private
		 */
		COMPILE::SWF
		public function set model(value:Object):void
		{
			if (_model != value)
			{
				addBead(value as IBead);
				dispatchEvent(new Event("modelChanged"));
			}
		}
		
		private var _view:IBeadView;
		
		/**
		 *  An IBeadView that serves as the view for the component.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 *  @flexjsignorecoercion Class
		 */
		public function get view():IBeadView
		{
			if (_view == null)
			{
				var c:Class = ValuesManager.valuesImpl.getValue(this, "iBeadView") as Class;
				if (c)
				{
					if (c)
					{
						_view = (new c()) as IBeadView;
						addBead(_view);
					}
				}
			}
			return _view;
		}
		
		/**
		 *  @private
		 */
		public function set view(value:IBeadView):void
		{
			if (_view != value)
			{
				addBead(value as IBead);
				dispatchEvent(new Event("viewChanged"));
			}
		}
		
		/**
		 *  @copy org.apache.flex.core.IUIBase#element
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get element():IFlexJSElement
		{
			return this;
		}
		
		/**
		 *  @copy org.apache.flex.core.Application#beads
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public var beads:Array;
		
		private var _beads:Vector.<IBead>;
		
		/**
		 *  @copy org.apache.flex.core.IStrand#addBead()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */        
		override public function addBead(bead:IBead):void
		{
			if (!_beads)
				_beads = new Vector.<IBead>;
			_beads.push(bead);
			if (bead is IBeadModel)
				_model = bead as IBeadModel;
			else if (bead is IBeadView)
				_view = bead as IBeadView;
			bead.strand = this;
			
			if (bead is IBeadView) {
				IEventDispatcher(this).dispatchEvent(new Event("viewChanged"));
			}
		}
		
		/**
		 *  @copy org.apache.flex.core.IStrand#getBeadByType()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function getBeadByType(classOrInterface:Class):IBead
		{
			for each (var bead:IBead in _beads)
			{
				if (bead is classOrInterface)
					return bead;
			}
			return null;
		}
		
		/**
		 *  @copy org.apache.flex.core.IStrand#removeBead()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function removeBead(value:IBead):IBead	
		{
			var n:int = _beads.length;
			for (var i:int = 0; i < n; i++)
			{
				var bead:IBead = _beads[i];
				if (bead == value)
				{
					_beads.splice(i, 1);
					return bead;
				}
			}
			return null;
		}
		
		
	}
	
	COMPILE::JS
	public class MovieClip extends Sprite
	{
		public function get totalFrames():int
		{
			return 1;
		}
		public function get framesLoaded():int
		{
			return 1;
		}
		
	}
}
