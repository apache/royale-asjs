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

package flashx.textLayout.ui
{
	import flash.geom.Rectangle;
	
	import mx.binding.utils.*;
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;

	public class PanelWithEdgeBars extends Canvas
	{
		public function PanelWithEdgeBars()
		{
			super();
			addEventListener(ResizeEvent.RESIZE, onResize);
		}
		
		public function set mainPanel(inPanel:UIComponent):void
		{
			if (mMainPanel == null)
			{
				mMainPanel = inPanel;
				ArrangeContents();
			}
			else if (mMainPanel != inPanel)
				throw new Error("Can't set main panel more than once.");
		}
		
		public function get mainPanel():UIComponent
		{
			return mMainPanel;
		}
		
		public function set topBar(inBar:UIComponent):void
		{
			if (mTopBar == null && inBar != null)
			{
				mTopBar = inBar;
				ArrangeContents();
				var watcherSetter:ChangeWatcher = BindingUtils.bindSetter(includeInLayoutChanged, mTopBar, "includeInLayout");
			}
			else if (mTopBar != inBar)
				throw new Error("Can't set any edge bar more than once.");
		}
		
		public function get topBar():UIComponent
		{
			return mTopBar;
		}
		
		public function set rightBar(inBar:UIComponent):void
		{
			if (mRightBar == null && inBar != null)
			{
				mRightBar = inBar;
				ArrangeContents();
				var watcherSetter:ChangeWatcher = BindingUtils.bindSetter(includeInLayoutChanged, mRightBar, "includeInLayout");
			}
			else if (mRightBar != inBar)
				throw new Error("Can't set any edge bar more than once.");
		}
		
		public function get rightBar():UIComponent
		{
			return mRightBar;
		}
		
		public function set bottomBar(inBar:UIComponent):void
		{
			if (mBottomBar == null && inBar != null)
			{
				mBottomBar = inBar;
				ArrangeContents();
				var watcherSetter:ChangeWatcher = BindingUtils.bindSetter(includeInLayoutChanged, mBottomBar, "includeInLayout");
			}
			else if (mBottomBar != inBar)
				throw new Error("Can't set any edge bar more than once.");
		}
		
		public function get bottomBar():UIComponent
		{
			return mBottomBar;
		}

		public function set leftBar(inBar:UIComponent):void
		{
			if (mLeftBar == null && inBar != null)
			{
				mLeftBar = inBar;
				ArrangeContents();
				var watcherSetter:ChangeWatcher = BindingUtils.bindSetter(includeInLayoutChanged, mLeftBar, "includeInLayout");
			}
			else if (mLeftBar != inBar)
				throw new Error("Can't set any edge bar more than once.");
		}
		
		public function get leftBar():UIComponent
		{
			return mLeftBar;
		}
		
		public function set edgeInset(inInset:Number):void
		{
			mEdgeInset = inInset;
			ArrangeContents();
		}
		
		public function get edgeInset():Number
		{
			return mEdgeInset;
		}
		
		public function set gap(inGap:Number):void
		{
			mGap = inGap;
			ArrangeContents();
		}
		
		public function get gap():Number
		{
			return mGap;
		}
		
		public function set leftInset(inInset:Number):void
		{
			mLeftInset = inInset;
			ArrangeContents();
		}
		
		public function get leftInset():Number
		{
			return mLeftInset;
		}
		
		public function set topInset(inInset:Number):void
		{
			mTopInset = inInset;
			ArrangeContents();
		}
		
		public function get topInset():Number
		{
			return mTopInset;
		}
		
		public function set rightInset(inInset:Number):void
		{
			mRightInset = inInset;
			ArrangeContents();
		}
		
		public function get rightInset():Number
		{
			return mRightInset;
		}
		
		public function set bottomInset(inInset:Number):void
		{
			mBottomInset = inInset;
			ArrangeContents();
		}
		
		public function get bottomInset():Number
		{
			return mBottomInset;
		}
		
		private function onResize(evt:ResizeEvent):void
		{
			ArrangeContents();
		}
		
		private function includeInLayoutChanged(val:Boolean):void {
		    ArrangeContents();
		}
            
		private function ArrangeContents():void
		{
			var space:Rectangle = new Rectangle(0, 0, width, height);
			for (var i:int = numChildren - 1; i >= 0; --i)
			{
				var child:UIComponent = getChildAt(i) as UIComponent;
				if (child && child.includeInLayout)
				{
					var inset:Number;
					if (child == mTopBar)
					{
						inset = mTopInset ? mTopInset : mEdgeInset;
						child.x = space.x;
						child.width = space.width;
						child.y = space.y;
						child.height = inset;
						space.y += inset + mGap;
						space.height -= inset + mGap;
					}
					else if (child == mRightBar)
					{
						inset = mRightInset ? mRightInset : mEdgeInset;
						child.x = space.right - inset;
						child.width = inset;
						child.y = space.y;
						child.height = space.height;
						space.width -= inset + mGap;
					}
					else if (child == mBottomBar)
					{
						inset = mBottomInset ? mBottomInset : mEdgeInset;
						child.x = space.x;
						child.width = space.width;
						child.y = space.bottom - inset;
						child.height = inset;
						space.height -= inset + mGap;
					}
					if (child == mLeftBar)
					{
						inset = mLeftInset ? mLeftInset : mEdgeInset;
						child.x = space.x;
						child.width = inset;
						child.y = space.y;
						child.height = space.height;
						space.x += inset + mGap;
						space.width -= inset + mGap;
					}
				}
			}
			if (mMainPanel)
			{
				mMainPanel.x = space.x;
				mMainPanel.y = space.y;
				mMainPanel.width = space.width;
				mMainPanel.height = space.height;
			}
		}
		
		private var mTopBar:UIComponent = null;
		private var mRightBar:UIComponent = null;
		private var mBottomBar:UIComponent = null;
		private var mLeftBar:UIComponent = null;
		private var mMainPanel:UIComponent = null;
		private var mEdgeInset:Number = 16;
		private var mLeftInset:Number = 0;
		private var mRightInset:Number = 0;
		private var mTopInset:Number = 0;
		private var mBottomInset:Number = 0;
		private var mGap:Number = 1;
	}
}