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

package org.apache.royale.effects
{
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IDocument;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.Strand;
	import org.apache.royale.events.Event;
	
	[DefaultProperty("children")]
	
	/**
	 *  CompoundEffect implements ICompoundEffect by dispatching events that should be handled by pluggable beads.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class CompoundEffect extends Strand implements IDocument, ICompoundEffect
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function CompoundEffect()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  The document.
		 */
		private var document:Object;
		
		/**
		 *  The target.
		 */
		public var target:IUIBase;
		
		private var _children:Array;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 *  The children.
		 */
		public function get children():Array
		{
			return _children;
		}

		public function set children(value:Array):void
		{
			_children = value;
		}

		private var _duration:Number = 500;
		public function set duration(value:Number):void
		{
			_duration = value;
			var n:int = children ? children.length : 0;
			for (var i:int = 0; i < n; i++)
			{
				children[i].duration = value;
			}
		}

		public function get duration():Number
		{
			return _duration;
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function setDocument(document:Object, id:String = null):void
		{
			this.document = document;
			for each (var bead:IBead in beads)
			{
				addBead(bead);
			}
		}
		
		public function addChild(child:IEffect):void
		{
			if (!children)
				children = [ child ];
			else
				children.push(child);    
		}
		
		public function captureEndValues():void
		{
			// TODO Auto Generated method stub
		}
		
		public function captureStartValues():void
		{
			// TODO Auto Generated method stub
		}
		
		public function play():void
		{
			dispatchEvent(new Event('play'));
		}
		
		public function pause():void
		{
			dispatchEvent(new Event('pause'));
		}
		
		public function resume():void
		{
			dispatchEvent(new Event('resume'));
		}
		
		public function reverse():void
		{
			dispatchEvent(new Event('reverse'));
		}
		
		public function stop():void
		{
			dispatchEvent(new Event('stop'));
		}
		
		public function addChildAt(e:IEffect, index:int):void
		{
			_children.insertAt(index, e);
		}
		
		public function getChildAt(index:int):IEffect
		{
			return _children[index];
		}
		
		public function getChildIndex(e:IEffect):int
		{
			return _children.indexOf(e);
		}
		
		public function get numChildren():int
		{
			return _children.length;
		}
		
		public function removeChild(e:IEffect):void
		{
			_children.removeAt(getChildIndex(e));
		}
		
	}
	
}
