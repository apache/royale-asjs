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

package spark.layouts.supportClasses
{
	import mx.core.UIComponent;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.LayoutBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import spark.components.supportClasses.GroupBase;
	import spark.components.supportClasses.SkinnableComponent;
	
	/**
	 *  The SparkLayoutBead class is a layout bead that pumps the Spark 
	 *  LayoutBase subclasses.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 0.9.6
	 */
	public class SparkLayoutBead extends org.apache.royale.core.LayoutBase
	{
		/**
		 *  Constructor. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 0.9.6
		 */    
		public function SparkLayoutBead()
		{
			super();
		}
		
		private var sawSizeChanged:Boolean;
		
		override protected function handleSizeChange(event:Event):void
		{
			sawSizeChanged = true;
			super.handleSizeChange(event);
		}
		
		override public function layout():Boolean
		{
			// NOTE: Can't test numChildren, due to virtual layouts
			//var n:int = target.numChildren;
			//if (n == 0)
			//	return false;
			
			var usingSkin:Boolean = false;
			if (host is SkinnableComponent)
				usingSkin = (host as SkinnableComponent).skin != null;
			
			if (!usingSkin && target != host)
			{
				var tlc:UIComponent = host as UIComponent;
				if (!tlc.isWidthSizedToContent() && !tlc.isHeightSizedToContent())
					target.setActualSize(tlc.width, tlc.height);
			}
			
			if (!isNaN(target.percentWidth) || !isNaN(target.percentHeight))
			{
				if (!sawSizeChanged)
					return false;
			}
			
			target.layout.layout();
			return true;
		}
		
		private var _strand:IStrand;
		
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			var host:UIBase = value as UIBase;
			_target = (host.view as ILayoutHost).contentView as GroupBase;
			super.strand = value;
		}
		
		private var _target:GroupBase;
		
		public function get target():GroupBase
		{
			return _target;
		}
		
		public function set target(value:GroupBase):void
		{
			_target = value;
		}
	}
	override protected function handleChildrenAdded(event:Event):void
	{
		COMPILE::JS {
			super.handleChildrenAdded(event);
			listenToChildren();
		}
	}
	
	private function listenToChildren():void
	{
		var n:Number = layoutView.numElements;
		for(var i:int=0; i < n; i++) {
			var child:IEventDispatcher = layoutView.getElementAt(i) as IEventDispatcher;
			child.addEventListener("widthChanged", childResizeHandler);
			child.addEventListener("heightChanged", childResizeHandler);
			child.addEventListener("sizeChanged", childResizeHandler);
		}
	}
	
	override protected function childResizeHandler(event:Event):void
	{
		if (inUpdateDisplayList) 
		{
			// children are resizing during layout.
			if (isNaN(target.explicitWidth) || isNaN(target.explicitHeight))
			{
				// that means our we need to be re-measured
				target.invalidateSize();
			}
			return;
		}
		ranLayout = false;
		super.childResizeHandler(event); // will set ranLayout if it did
		if (!ranLayout)
			performLayout();
	}		
		
}
