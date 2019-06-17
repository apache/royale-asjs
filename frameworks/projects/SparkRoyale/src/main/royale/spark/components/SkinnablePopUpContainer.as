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

package spark.components
{
	/*
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.events.SoftKeyboardTrigger;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	*/
	
	import mx.core.EventPriority;
	import mx.core.FlexGlobals;
	import mx.core.FlexVersion;
	import mx.core.mx_internal;
		
	//import mx.effects.Parallel;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	import mx.events.SandboxMouseEvent;
	import mx.managers.PopUpManager;
	import mx.managers.SystemManager;
	// import mx.styles.StyleProtoChain;
	
	// import mx.effects.IEffect;
	// import spark.effects.Move;
	// import spark.effects.Resize;

	import org.apache.royale.events.Event;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.utils.Timer;
	
	import org.apache.royale.effects.IEffect;
	import org.apache.royale.effects.Move;
	import org.apache.royale.effects.Resize;
	
	import mx.core.UIComponent;

	// import spark.effects.animation.Animation;
	// import spark.effects.easing.IEaser;
	// import spark.effects.easing.Power;
	import spark.events.PopUpEvent;
	
	use namespace mx_internal;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched by the container when it's opened and ready for user interaction.
	 *
	 *  <p>This event is dispatched when the container switches from the
	 *  <code>closed</code> to <code>normal</code> skin state and the transition
	 *  to that state completes.</p>
	 *
	 *  <p>Note: As of Flex 4.6, SkinnablePopUp container inherits its styles
	 *  from the stage and not its owner.</p>
	 *
	 *  @eventType spark.events.PopUpEvent.OPEN
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	[Event(name="open", type="spark.events.PopUpEvent")]
	
	/**
	 *  Dispatched by the container when it's closed.
	 *
	 *  <p>This event is dispatched when the container switches from the
	 *  <code>normal</code> to <code>closed</code> skin state and
	 *  the transition to that state completes.</p>
	 *
	 *  <p>The event provides a mechanism to pass commit information from
	 *  the container to an event listener.
	 *  One typical usage scenario is building a multiple-choice dialog with a
	 *  cancel button.
	 *  When a valid option is selected, you close the pop up
	 *  with a call to the <code>close()</code> method, passing
	 *  <code>true</code> to the <code>commit</code> parameter and optionally passing in
	 *  any relevant data.
	 *  When the SkinnablePopUpContainer has completed closing,
	 *  it dispatches this event.
	 *  Then, in the event listener, you can check the <code>commit</code>
	 *  property and perform the appropriate action.  </p>
	 *
	 *  @eventType spark.events.PopUpEvent.CLOSE
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	[Event(name="close", type="spark.events.PopUpEvent")]
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	/**
	 *  Duration of the soft keyboard move and resize effect in milliseconds.
	 *
	 *  @default 150
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 11
	 *  @playerversion AIR 3.1
	 *  @productversion Flex 4.6
	 */
	[Style(name="softKeyboardEffectDuration", type="Number", format="Time", inherit="no", minValue="0.0")]
	
	//--------------------------------------
	//  States
	//--------------------------------------
	
	/**
	 *  The closed state.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	[SkinState("closed")]
	
	/**
	 *  The SkinnablePopUpContainer class is a SkinnableContainer that functions as a pop-up.
	 *  One typical use for a SkinnablePopUpContainer container is to open a simple window
	 *  in an application, such as an alert window, to indicate that the user must perform some action.
	 *
	 *  <p>You do not create a SkinnablePopUpContainer container as part of the normal layout
	 *  of its parent container.
	 *  Instead, it appears as a pop-up window on top of its parent.
	 *  Therefore, you do not create it directly in the MXML code of your application.</p>
	 *
	 *  <p>Instead, you create is as an MXML component, often in a separate MXML file.
	 *  To show the component create an instance of the MXML component, and
	 *  then call the <code>open()</code> method.
	 *  You can also set the size and position of the component when you open it.</p>
	 *
	 *  <p>To close the component, call the <code>close()</code> method.
	 *  If the pop-up needs to return data to a handler, you can add an event listener for
	 *  the <code>PopUp.CLOSE</code> event, and specify the returned data in
	 *  the <code>close()</code> method.</p>
	 *
	 *  <p>The SkinnablePopUpContainer is initially in its <code>closed</code> skin state.
	 *  When it opens, it adds itself as a pop-up to the PopUpManager,
	 *  and transition to the <code>normal</code> skin state.
	 *  To define open and close animations, use a custom skin with transitions between
	 *  the <code>closed</code> and <code>normal</code> skin states.</p>
	 *
	 *  <p>The SkinnablePopUpContainer container has the following default characteristics:</p>
	 *     <table class="innertable">
	 *     <tr><th>Characteristic</th><th>Description</th></tr>
	 *     <tr><td>Default size</td><td>Large enough to display its children</td></tr>
	 *     <tr><td>Minimum size</td><td>0 pixels</td></tr>
	 *     <tr><td>Maximum size</td><td>10000 pixels wide and 10000 pixels high</td></tr>
	 *     <tr><td>Default skin class</td><td>spark.skins.spark.SkinnablePopUpContainerSkin</td></tr>
	 *     </table>
	 *
	 *  @mxml <p>The <code>&lt;s:SkinnablePopUpContainer&gt;</code> tag inherits all of the tag
	 *  attributes of its superclass and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;s:SkinnablePopUpContainer
	 *    <strong>Events</strong>
	 *    close="<i>No default</i>"
	 *    open="<i>No default</i>"
	 *  /&gt;
	 *  </pre>
	 *
	 *  @see spark.skins.spark.SkinnablePopUpContainerSkin
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	public class SkinnablePopUpContainer extends SkinnableContainer
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
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function SkinnablePopUpContainer()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Storage for the close event while waiting for the close transition to
		 *  complete before dispatching it.
		 *
		 *  @private
		 */
		private var closeEvent:PopUpEvent;
		
		/**
		 *  Track whether the container is added to the PopUpManager.
		 *
		 *  @private
		 */
		private var addedToPopUpManager:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Soft Keyboard Effect Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  The current soft keyboard effect instance. This field is only set in
		 *  cases where the position and size are not snapped during (a) initial
		 *  activation and (b) deactivation.
		 */
		private var softKeyboardEffect:IEffect;
		
		/**
		 *  @private
		 *  Original pop-up y-position.
		 */
		private var softKeyboardEffectCachedYPosition:Number;
		
		/**
		 *  @private
		 *  Indicates a soft keyboard event was received but the effect is delayed
		 *  while waiting for a mouseDown and mouseUp event sequence.
		 */
		private var softKeyboardEffectPendingEventType:String = null;
		
		/**
		 *  @private
		 *  Number of milliseconds to wait for a mouseDown and mouseUp event
		 *  sequence before playing the deactivate effect.
		 */
		mx_internal var softKeyboardEffectPendingEffectDelay:Number = 100;
		
		/**
		 *  @private
		 *  Timer used for awaiting a mouseDown event after a pending soft keyboard
		 *  effect.
		 */
		private var softKeyboardEffectPendingEventTimer:Timer;
		
		/**
		 *  @private
		 *  Flag when orientationChanging is dispatched and orientationChange has
		 *  not been received.
		 */
		private var softKeyboardEffectOrientationChanging:Boolean = false;
		
		/**
		 *  @private
		 *  Flag when orientation change handlers are installed to suppress
		 *  excess soft keyboard effects during orientation change on iOS.
		 */
		private var softKeyboardEffectOrientationHandlerAdded:Boolean = false;
		
		/**
		 *  @private
		 *  Flag when mouse and orientation listeners are installed before
		 *  the soft keyboard activate effect is played.
		 */
		private var softKeyboardStateChangeListenersInstalled:Boolean;
		
		/**
		 *  @private
		 *  Flag when resize listers are installed after ACTIVATE and uninstalled
		 *  just before DEACTIVATE.
		 */
		private var resizeListenerInstalled:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  isOpen
		//----------------------------------
		
		/**
		 *  Storage for the isOpen property.
		 *
		 *  @private
		 */
		private var _isOpen:Boolean = false;
		
		[Inspectable(category="General", defaultValue="false")]
		
		/**
		 *  Contains <code>true</code> when the container is open and is currently showing as a pop-up.
		 *
		 *  @see #open
		 *  @see #close
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		/**
		 *  Updates the isOpen flag to be reflected in the skin state
		 *  without actually popping up the container through the PopUpManager.
		 *
		 *  @private
		 */
		mx_internal function setIsOpen(value:Boolean):void
		{
			// NOTE: DesignView relies on this API, consult tooling before making changes.
			_isOpen = value;
			invalidateSkinState();
		}
		
		//----------------------------------
		//  resizeForSoftKeyboard
		//----------------------------------
		
		private var _resizeForSoftKeyboard:Boolean = true;
		
		/**
		 *  Enables resizing the pop-up when the soft keyboard
		 *  on a mobile device is active.
		 *
		 *  @default true
		 *
		 *  @langversion 3.0
		 *  @playerversion AIR 3
		 *  @productversion Flex 4.6
		 */
		public function get resizeForSoftKeyboard():Boolean
		{
			return _resizeForSoftKeyboard;
		}
		
		/**
		 *  @private
		 */
		public function set resizeForSoftKeyboard(value:Boolean):void
		{
			if (_resizeForSoftKeyboard == value)
				return;
			
			_resizeForSoftKeyboard = value;
		}
		
		//----------------------------------
		//  moveForSoftKeyboard
		//----------------------------------
		
		private var _moveForSoftKeyboard:Boolean = true;
		
		/**
		 *  Enables moving the pop-up when the soft keyboard
		 *  on a mobile device is active.
		 *
		 *  @default true
		 *
		 *  @langversion 3.0
		 *  @playerversion AIR 3
		 *  @productversion Flex 4.6
		 */
		public function get moveForSoftKeyboard():Boolean
		{
			return _moveForSoftKeyboard;
		}
		
		/**
		 *  @private
		 */
		public function set moveForSoftKeyboard(value:Boolean):void
		{
			if (_moveForSoftKeyboard == value)
				return;
			
			_moveForSoftKeyboard = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Opens the container as a pop-up, and switches the skin state from
		 *  <code>closed</code> to <code>normal</code>.
		 *  After and transitions finish playing, it dispatches  the
		 *  <code>FlexEvent.OPEN</code> event.
		 *
		 *  @param owner The owner of the container.
		 *  The popup appears over this component. The owner must not be descendant
		 *  of this container.
		 *
		 *  @param modal Whether the container should be modal.
		 *  A modal container takes all keyboard and mouse input until it is closed.
		 *  A nonmodal container allows other components to accept input while the pop-up window is open.
		 *
		 *  @see #close
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function open(owner:UIComponent /*DisplayObjectContainer*/, modal:Boolean = false):void
		{
			if (isOpen)
				return;
			
			closeEvent = null; // Clear any pending close event
			this.owner = owner;
			
			// We track whether we've been added to the PopUpManager to handle the
			// scenario of state transition interrupton. For example we may be playing
			// a close transition and be interrupted with a call to open() in which
			// case we wouldn't have removed the container from the PopUpManager since
			// the close transition never reached its end.
			if (!addedToPopUpManager)
			{
				addedToPopUpManager = true;
				
				// This will create the skin and attach it
				PopUpManager.addPopUp(this, owner, modal);
				
				updatePopUpPosition();
			}
			
			// Change state *after* we pop up, as the skin needs to go be in the initial "closed"
			// state while being created above in order for transitions to detect state change and play.
			_isOpen = true;
			invalidateSkinState();
			if (skin)
				skin.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, stateChangeComplete_handler);
			else
				stateChangeComplete_handler(null); // Call directly
		}
		
		/**
		 *  Positions the pop-up after the pop-up is added to PopUpManager but
		 *  before any state transitions occur. The base implementation of open()
		 *  calls updatePopUpPosition() immediately after the pop-up is added.
		 *
		 *  This method may also be called at any time to update the pop-up's
		 *  position. Pop-ups that are positioned relative to their owner should
		 *  call this method after position or size changes occur on the owner or
		 *  it's ancestors.
		 *
		 *  @langversion 3.0
		 *  @playerversion AIR 3
		 *  @productversion Flex 4.6
		 */
		public function updatePopUpPosition():void
		{
			// subclasses will implement custom positioning
			// e.g. PopUpManager.centerPopUp()
		}
		
		/**
		 *  Changes the current skin state to <code>closed</code>, waits until any state transitions
		 *  finish playing, dispatches a <code>PopUpEvent.CLOSE</code> event,
		 *  and then removes the container from the PopUpManager.
		 *
		 *  <p>Use the <code>close()</code> method of the SkinnablePopUpContainer container
		 *  to pass data back to the main application from the pop up.
		 *  One typical usage scenario is building a dialog with a cancel button.
		 *  When a valid option is selected in the dialog box, you close the dialog
		 *  with a call to the <code>close()</code> method, passing
		 *  <code>true</code> to the <code>commit</code> parameter and optionally passing
		 *  any relevant data.
		 *  When the SkinnablePopUpContainer has completed closing,
		 *  it dispatch the <code>close</code> event.
		 *  In the event listener for the <code>close</code> event, you can check
		 *  the <code>commit</code> parameter and perform the appropriate actions.  </p>
		 *
		 *  @param commit Specifies if the return data should be committed by the application.
		 *  The value of this argument is written to the <code>commit</code> property of
		 *  the <code>PopUpEvent</code> event object.
		 *
		 *  @param data Specifies any data returned to the application.
		 *  The value of this argument is written to the <code>data</code> property of
		 *  the <code>PopUpEvent</code> event object.
		 *
		 *  @see #open
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function close(commit:Boolean = false, data:* = undefined):void
		{
			if (!isOpen)
				return;
			
			// We will dispatch the event later, when the close transition is complete.
			closeEvent = new PopUpEvent(PopUpEvent.CLOSE, false, false, commit, data);
			
			// Change state
			_isOpen = false;
			invalidateSkinState();
			
			if (skin)
				skin.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, stateChangeComplete_handler);
			else
				stateChangeComplete_handler(null); // Call directly
		}
		
		/**
		 *  Called by the soft keyboard <code>activate</code> and <code>deactive</code> event handlers,
		 *  this method is responsible for creating the Spark effect played on the pop-up.
		 *
		 *  This method may be overridden by subclasses. By default, it
		 *  creates a parellel move and resize effect on the pop-up.
		 *
		 *  @param yTo The new y-coordinate of the pop-up.
		 *
		 *  @param height The new height of the pop-up.
		 *
		 *  @return An IEffect instance serving as the move and/or resize transition
		 *  for the pop-up. This effect is played after the soft keyboard is
		 *  activated or deactivated.
		 *
		 *  @langversion 3.0
		 *  @playerversion AIR 3
		 *  @productversion Flex 4.6
		 */
		protected function createSoftKeyboardEffect(yTo:Number, heightTo:Number):IEffect
		{/*
			var move:Move;
			var resize:Resize;
			var easer:IEaser = new Power(0, 5);
			
			if (yTo != this.y)
			{
				move = new Move();
				move.target = this;
				move.yTo = yTo;
				move.disableLayout = true;
				move.easer = easer;
			}
			
			if (heightTo != this.height)
			{
				resize = new Resize();
				resize.target = this;
				resize.heightTo = heightTo;
				resize.disableLayout = true;
				resize.easer = easer;
			}
			
			if (move && resize)
			{
				var parallel:Parallel = new Parallel();
				parallel.addChild(move);
				parallel.addChild(resize);
				
				return parallel;
			}
			else if (move || resize)
			{
				return (move) ? move : resize;
			}*/
			
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  mx_internal properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------------
		//  softKeyboardEffectCachedExplicitHeight
		//----------------------------------------
		
		/**
		 *  @private
		 */
		private var _softKeyboardEffectExplicitHeightFlag:Boolean = false;
		
		/**
		 *  @private
		 *  Flag when explicitHeight is set when the soft keyboard effect is
		 *  active. Use this to distinguish explicitHeight changes due to the
		 *  resizeForSoftKeyboard setting. When true, we prevent the original
		 *  cached height from being modified.
		 */
		mx_internal function get softKeyboardEffectExplicitHeightFlag():Boolean
		{
			return _softKeyboardEffectExplicitHeightFlag;
		}
		
		private function setSoftKeyboardEffectExplicitHeightFlag(value:Boolean):void
		{
			_softKeyboardEffectExplicitHeightFlag = value;
		}
		
		//----------------------------------------
		//  softKeyboardEffectCachedExplicitWidth
		//----------------------------------------
		
		/**
		 *  @private
		 */
		private var _softKeyboardEffectExplicitWidthFlag:Boolean = false;
		
		/**
		 *  @private
		 *  Flag when explicitWidth is set when the soft keyboard effect is
		 *  active. Use this to distinguish explicitWidth changes due to the
		 *  resizeForSoftKeyboard setting.
		 */
		mx_internal function get softKeyboardEffectExplicitWidthFlag():Boolean
		{
			return _softKeyboardEffectExplicitWidthFlag;
		}
		
		private function setSoftKeyboardEffectExplicitWidthFlag(value:Boolean):void
		{
			_softKeyboardEffectExplicitWidthFlag = value;
		}
		
		//----------------------------------
		//  softKeyboardEffectCachedHeight
		//----------------------------------
		
		private var _softKeyboardEffectCachedHeight:Number;
		
		/**
		 *  @private
		 *  The original pop-up height to restore to when the soft keyboard is
		 *  deactivated. If an explicitHeight was defined at activation, use it.
		 *  If not, then use explicitMaxHeight or measuredHeight.
		 */
		mx_internal function get softKeyboardEffectCachedHeight():Number
		{
			var heightTo:Number = _softKeyboardEffectCachedHeight;
			
			if (!softKeyboardEffectExplicitHeightFlag)
			{
				if (!isNaN(explicitMaxHeight) && (measuredHeight > explicitMaxHeight))
					heightTo = explicitMaxHeight;
				else
					heightTo = measuredHeight;
			}
			
			return heightTo;
		}
		
		/**
		 *  @private
		 */
		private function setSoftKeyboardEffectCachedHeight(value:Number):void
		{
			// Only allow changes to the cached height if it was not set explicitly
			// prior to and/or during the soft keyboard effect.
			if (!softKeyboardEffectExplicitHeightFlag)
				_softKeyboardEffectCachedHeight = value;
		}
		
		//----------------------------------
		//  isSoftKeyboardEffectActive
		//----------------------------------
		
		private var _isSoftKeyboardEffectActive:Boolean;
		
		/**
		 *  @private
		 *  Returns true if the soft keyboard is active and the pop-up is moved
		 *  and/or resized.
		 */
		mx_internal function get isSoftKeyboardEffectActive():Boolean
		{
			return _isSoftKeyboardEffectActive;
		}
		
		//----------------------------------
		//  marginTop
		//----------------------------------
		
		private var _marginTop:Number = 0;
		
		/**
		 *  @private
		 *  Defines a margin at the top of the screen where the pop-up cannot be
		 *  resized or moved to.
		 */
		mx_internal function get softKeyboardEffectMarginTop():Number
		{
			return _marginTop;
		}
		
		/**
		 *  @private
		 */
		mx_internal function set softKeyboardEffectMarginTop(value:Number):void
		{
			_marginTop = value;
		}
		
		//----------------------------------
		//  marginBottom
		//----------------------------------
		
		private var _marginBottom:Number = 0;
		
		/**
		 *  @private
		 *  Defines a margin at the bottom of the screen where the pop-up cannot be
		 *  resized or moved to.
		 */
		mx_internal function get softKeyboardEffectMarginBottom():Number
		{
			return _marginBottom;
		}
		
		/**
		 *  @private
		 */
		mx_internal function set softKeyboardEffectMarginBottom(value:Number):void
		{
			_marginBottom = value;
		}
		
		//----------------------------------
		//  isMouseDown
		//----------------------------------
		
		private var _isMouseDown:Boolean = false;
		
		/**
		 *  @private
		 */
		private function get isMouseDown():Boolean
		{
			return _isMouseDown;
		}
		
		/**
		 *  @private
		 */
		private function set isMouseDown(value:Boolean):void
		{
			_isMouseDown = value;
			
			// Attempt to play a pending effect
			playPendingEffect(true);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Force callout inheritance chain to start at the style root.
		 */
		/*override mx_internal function initProtoChain():void
		{
			// Maintain backwards compatibility of popup style inheritance
			if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_6)
				super.initProtoChain();
			else
				StyleProtoChain.initProtoChain(this, false);
		}*/
		
		/**
		 *  @private
		 */
		override protected function getCurrentSkinState():String
		{
			// The states are:
			// "normal"
			// "disabled"
			// "closed"
			
			var state:String = super.getCurrentSkinState();
			if (!isOpen)
				return state == "normal" ? "closed" : state;
			return state;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Play the soft keyboard effect.
		 */
		private function startEffect(event:Event):void
		{/*
			removeEventListener(Event.ENTER_FRAME, startEffect);
			
			// Abort the effect if the pop-up is closed or closing. The state 
			// transition handler will restore the original size of the pop-up.
			if (!isOpen || !softKeyboardEffect)
				return;
			
			// Clear the cached positions when the deactivate effect is complete.
			softKeyboardEffect.addEventListener(EffectEvent.EFFECT_END, softKeyboardEffectCleanup);
			softKeyboardEffect.addEventListener(EffectEvent.EFFECT_STOP, softKeyboardEffectCleanup);
			
			// Install mouse delay and orientation change listeners now.
			// explicitHeight listener is installed after the effect completes.
			if (isSoftKeyboardEffectActive)
				installSoftKeyboardStateChangeListeners();
			
			// Force the master clock of the animation engine to update its
			// current time so that the overhead of creating the effect is not
			// included in our animation interpolation. See SDK-27793
			Animation.pulse();
			softKeyboardEffect.play();*/
		}
		
		/**
		 *  @private
		 *
		 *  Called when we have completed transitioning to opened/closed state.
		 */
		private function stateChangeComplete_handler(event:Event):void
		{/*
			// We get called directly with null if there's no skin to listen to.
			if (event)
				event.target.removeEventListener(FlexEvent.STATE_CHANGE_COMPLETE, stateChangeComplete_handler);
			
			// Check for soft keyboard support
			var topLevelApp:Application = FlexGlobals.topLevelApplication as Application;
			var softKeyboardEffectEnabled:Boolean = (topLevelApp && Application.softKeyboardBehavior == "none");
			var smStage:Stage = systemManager.stage;
			
			if (isOpen)
			{
				dispatchEvent(new PopUpEvent(PopUpEvent.OPEN, false, false));
				
				if (softKeyboardEffectEnabled)
				{
					if (smStage)
					{
						// Install soft keyboard event handling on the stage
						smStage.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,
							stage_softKeyboardActivateHandler, true, EventPriority.DEFAULT, true);
						smStage.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,
							stage_softKeyboardDeactivateHandler, true, EventPriority.DEFAULT, true);
						
						// Use lower priority listener to allow subclasses to act 
						// on the resize event before the soft keyboard effect does.
						systemManager.addEventListener(Event.RESIZE, systemManager_resizeHandler, false, EventPriority.EFFECT);
						
						updateSoftKeyboardEffect(true);
					}
				}
			}
			else
			{
				// Dispatch the close event before removing from the PopUpManager.
				dispatchEvent(closeEvent);
				closeEvent = null;
				
				if (softKeyboardEffectEnabled && smStage)
				{
					// Uninstall soft keyboard event handling
					smStage.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,
						stage_softKeyboardActivateHandler, true);
					smStage.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,
						stage_softKeyboardDeactivateHandler, true);
					systemManager.removeEventListener(Event.RESIZE, systemManager_resizeHandler);
				}
				
				// We just finished closing, remove from the PopUpManager.
				PopUpManager.removePopUp(this);
				addedToPopUpManager = false;
				owner = null;
				
				// Position and size may be invalid if the close transition
				// completes before (a) deactivate is fired or (b) a pending
				// soft keyboard change is still queued. Update immediately.
				updateSoftKeyboardEffect(true);
			}*/
		}
		
		/**
		 *  @private
		 */
		/*private function stage_softKeyboardActivateHandler(event:SoftKeyboardEvent=null):void
		{
			var isFirstActivate:Boolean = false;
			
			// Reset state
			softKeyboardEffectPendingEventType = null;
			
			// Save the original y-position and height if this is the first
			// ACTIVATE event and an existing effect is not already in progress.
			if (!isSoftKeyboardEffectActive && !softKeyboardEffect)
				isFirstActivate = true;
			
			if (isFirstActivate)
			{
				// Play the activate effect with animation
				updateSoftKeyboardEffect(false);
			}
			else
			{
				// Keyboard height has changed. However, the effect can be delayed if
				// a mouseUp within the pop-up is pending. An additional activate can
				// occur while the keyboard is open to reflect size changes due to auto
				// correction or orientation changes.
				
				// As in the deactivate case, the move and resize effects should be
				// delayed until the user can complete any mouse interaction. This
				// allows the size and position of the pop-up to stay stable allowing
				// events like a button press to complete normally.
				
				if (isMouseDown)
					setPendingSoftKeyboardEvent(event);
				else
					updateSoftKeyboardEffect(true);
			}
		}*/
		
		/**
		 *  @private
		 */
		/*private function stage_softKeyboardDeactivateHandler(event:SoftKeyboardEvent=null):void
		{
			// If the effect is not active (no move or resize was needed), do 
			// nothing. If we're in the middle of an orientation change, also do 
			// nothing.
			if (!isSoftKeyboardEffectActive || softKeyboardEffectOrientationChanging)
				return;
			
			// Reset state
			softKeyboardEffectPendingEventType = null;
			
			if (event.triggerType == SoftKeyboardTrigger.USER_TRIGGERED)
			{
				// userTriggered indicates they keyboard was closed explicitly (soft
				// button on soft keyboard) or on Android, pressing the back button.
				// Play the deactivate effect immediately.
				updateSoftKeyboardEffect(false);
			}
			else // if (event.triggerType == SoftKeyboardTrigger.CONTENT_TRIGGERED)
			{
				// contentTriggered indicates focus was lost by tapping away from
				// StageText or a programmatic call. Unfortunately, this
				// distinction isn't entirely intuitive. We only care about delaying
				// the deactivate effect when due to a mouse event. Delaying the
				// effect allows the pop-up position and size to stay static until
				// any mouse interaction is complete (e.g. button click).
				// However, the softKeyboardDeactivate event is fired before
				// the mouseDown event:
				//   deactivate -> mouseDown -> mouseUp
				
				// The approach here is to assume that a mouseDown was the trigger
				// for the softKeyboardDeactivate event. Continue to delay the
				// deactivate effect until a mouseDown and mouseUp sequence is
				// received. In the event that the deactivation was due to a
				// programmatic call, we'll stop this process after a specified
				// delay time.
				
				// If, in the future, the event order changes to either:
				//   (a) mouseDown -> deactivate -> mouseUp
				//   (b) mouseDown -> mouseUp -> deactivate
				// this approach will still work for the button click use case.
				// Sequence (b) would simply fire a normal button click and have
				// the consequence of a delayed deactivate effect only.
				setPendingSoftKeyboardEvent(event);
			}
		}*/
		
		/**
		 *  @private
		 *  Disable soft keyboard deactivate when orientation is changing.
		 */
		private function stage_orientationChangingHandler(event:Event):void
		{
			softKeyboardEffectOrientationChanging = true;
		}
		
		/**
		 *  @private
		 *  Re-enable soft keyboard deactivate effect when orietation change 
		 *  completes.
		 */
		private function stage_orientationChangeHandler(event:Event):void
		{
			softKeyboardEffectOrientationChanging = false;
		}
		
		/**
		 *  @private
		 *  Listens for mouse events while the soft keyboard effect is active.
		 */
		private function mouseHandler(event:MouseEvent):void
		{
			isMouseDown = (event.type == MouseEvent.MOUSE_DOWN);
		}
		
		private function systemManager_mouseUpHandler(event:Event):void
		{
			isMouseDown = false;
		}
		
		/**
		 *  @private
		 *  This function is only called when the pendingEffectTimer completed and no
		 *  mouseDown and mouseUp sequence was fired.
		 */
		private function pendingEffectTimer_timerCompleteHandler(event:Event):void
		{
			playPendingEffect(false)
		}
		
		/**
		 *  @private
		 *  Play the effect when (a) not triggered by a mouse event or
		 *  (b) triggered by a mouseUp event
		 */
		private function playPendingEffect(isMouseEvent:Boolean):void
		{/*
			var isTimerRunning:Boolean = softKeyboardEffectPendingEventTimer && softKeyboardEffectPendingEventTimer.running;
			
			// Received a mouseDown event while the timer is still running. Stop
			// the timer and wait for the next mouseUp.
			var mouseDownDuringTimer:Boolean = isTimerRunning &&
				(isMouseEvent && isMouseDown);
			
			// Cleanup the timer if we're (a) waiting for the next mouseUp or
			// (b) this function was called for timerComplete
			if (softKeyboardEffectPendingEventTimer && (mouseDownDuringTimer || !isMouseEvent))
			{
				softKeyboardEffectPendingEventTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, pendingEffectTimer_timerCompleteHandler);
				softKeyboardEffectPendingEventTimer.stop();
				softKeyboardEffectPendingEventTimer = null;
				
				// If we caught a mouse down during the timer, we wait for the next
				// mouseUp event. There is no effect to play. If this isn't a mouse
				// event and the timer completed, then fall through and play the
				// pending effect.
				if (mouseDownDuringTimer)
					return;
			}
			
			// Sanity check that a pendingEvent still exists and that the pop-up
			// is currently open. If we timed out or if we got a mouseUp, then
			// allow the pending effect to play.
			var canPlayEffect:Boolean = softKeyboardEffectPendingEventType && isOpen &&
				(!isMouseEvent || (isMouseEvent && !isMouseDown));
			
			// Effect isn't played when still waiting for a mouseUp
			if (canPlayEffect)
			{
				// Clear pending state
				var isActivate:Boolean = softKeyboardEffectPendingEventType == SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE;
				
				// Snap the position only for pending activate events
				updateSoftKeyboardEffect(isActivate);
			}*/
		}
		
		/**
		 *  @private
		 */
		private function softKeyboardEffectCleanup(event:EffectEvent):void
		{
			// Cleanup effect
			softKeyboardEffect.removeEventListener(EffectEvent.EFFECT_END, softKeyboardEffectCleanup);
			softKeyboardEffect.removeEventListener(EffectEvent.EFFECT_STOP, softKeyboardEffectCleanup);
			softKeyboardEffect = null;
			
			if (isSoftKeyboardEffectActive)
			{
				installActiveResizeListener();
			}
			else
			{
				// Remove resize listeners
				uninstallActiveResizeListener();
				
				// If the deactivate effect is complete, uninstall listeners for 
				// mouse delay and orientation change listeners
				uninstallSoftKeyboardStateChangeListeners();
			}
		}
		
		/**
		 *  @private
		 *  Set flags when explicit size changes are detected.
		 */
		private function resizeHandler(event:Event=null):void
		{
			setSoftKeyboardEffectExplicitWidthFlag(!isNaN(explicitWidth));
			setSoftKeyboardEffectExplicitHeightFlag(!isNaN(explicitHeight));
		}
		
		/**
		 *  @private
		 *  Update effect immediately after orientation change is
		 *  followed by a system manager resize.
		 */
		private function systemManager_resizeHandler(event:Event):void
		{
			// Guard against extraneous resizing during orientation changing.
			// See SDK-31860.
			if (!softKeyboardEffectOrientationChanging)
				updateSoftKeyboardEffect(true);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Update the position and height for this pop-up for various state changes
		 *  including: soft keyboard activation and deactivation, delayed soft
		 *  keyboard events due to mouse and keyboard event sequence, and
		 *  orientation change events.
		 */
		private function updateSoftKeyboardEffect(snapPosition:Boolean):void
		{/*
			// Stop the current effect
			if (softKeyboardEffect && softKeyboardEffect.isPlaying)
				softKeyboardEffect.stop();
			
			// Uninstall resize listeners during the effect. Listeners are 
			// installed again after the effect is complete or immediately affter
			// the size and position are snapped.
			uninstallActiveResizeListener();
			
			var softKeyboardRect:Rectangle;
			try {
				softKeyboardRect = FlexGlobals.topLevelApplication.softKeyboardRect;
			}
			catch (error:Error) {
				softKeyboardRect = null;
			}
			
			var isKeyboardOpen:Boolean = isOpen && softKeyboardRect && (softKeyboardRect.height > 0);
			
			// Capture start values if not set
			if (isNaN(softKeyboardEffectCachedYPosition))
			{
				if (isKeyboardOpen)
				{
					// Save original y-position and height
					softKeyboardEffectCachedYPosition = this.y;
					setSoftKeyboardEffectCachedHeight(this.height);
					
					// Initialize explicit size flags
					resizeHandler();
				}
				else
				{
					// Keyboard is closed and we don't have any start values yet.
					// Nothing to do.
					return;
				}
			}
			
			var sandboxRoot:UIComponent = systemManager.getSandboxRoot();
			
			var yToLocal:Number = softKeyboardEffectCachedYPosition;
			var heightToLocal:Number = softKeyboardEffectCachedHeight;
			
			// If the keyboard is active, check for overlap
			if (isKeyboardOpen)
			{
				var scaleFactor:Number = 1;
				
				if (systemManager as SystemManager)
					scaleFactor = SystemManager(systemManager).densityScale;
				
				// All calculations are done in stage coordinates and converted back to
				// application coordinates when playing effects. Also note that
				// softKeyboardRect is also in stage coordinates.
				var popUpY:Number = yToLocal * scaleFactor;
				var popUpHeight:Number = heightToLocal * scaleFactor;
				var overlapGlobal:Number = (popUpY + popUpHeight) - softKeyboardRect.y;
				
				var yToGlobal:Number = popUpY;
				var heightToGlobal:Number = popUpHeight;
				
				if (overlapGlobal > 0)
				{
					// shift y-position up to remove offset overlap
					if (moveForSoftKeyboard)
						yToGlobal = Math.max((softKeyboardEffectMarginTop * scaleFactor), (popUpY - overlapGlobal));
					
					// adjust height based on new y-position
					if (resizeForSoftKeyboard)
					{
						// compute new overlap
						overlapGlobal = (yToGlobal + popUpHeight) - softKeyboardRect.y;
						
						// adjust height if there is overlap
						if (overlapGlobal > 0)
							heightToGlobal = popUpHeight - overlapGlobal - (softKeyboardEffectMarginBottom * scaleFactor);
					}
				}
				
				if ((yToGlobal != popUpY) ||
					(heightToGlobal != popUpHeight))
				{
					// convert to application coordinates, move to pixel boundaries
					yToLocal = Math.floor(yToGlobal / scaleFactor);
					heightToLocal = Math.floor(heightToGlobal / scaleFactor);
					
					// preserve minimum height
					heightToLocal = Math.max(heightToLocal, getMinBoundsHeight());
				}
			}
			
			// Update state
			_isSoftKeyboardEffectActive = isKeyboardOpen;
			
			var duration:Number = getStyle("softKeyboardEffectDuration");
			
			// Only create an effect when not snapping and the duration is
			// non-negative. An effect will not be created by default if there is
			// no change.
			if (!snapPosition && (duration > 0))
				softKeyboardEffect = createSoftKeyboardEffect(yToLocal, heightToLocal);
			
			if (softKeyboardEffect)
			{
				softKeyboardEffect.duration = duration;
				
				// Wait a frame so that any queued work can be completed by the framework
				// and runtime before the effect starts.
				addEventListener(Event.ENTER_FRAME, startEffect);
			}
			else
			{
				// No effect, snap. Set position and size explicitly.
				this.y = yToLocal;
				
				if (isOpen)
				{
					this.height = heightToLocal;
					
					// Validate so that other listeners like Scroller get the 
					// updated dimensions.
					validateNow();
					
					if (isSoftKeyboardEffectActive)
					{
						installActiveResizeListener();
						installSoftKeyboardStateChangeListeners();
					}
				}
				else // if (!isOpen)
				{
					// Uninstall mouse delay and orientation change listeners
					uninstallSoftKeyboardStateChangeListeners();
					
					// Clear explicit size leftover from Resize
					softKeyboardEffectResetExplicitSize();
					
					// Clear start values
					softKeyboardEffectCachedYPosition = NaN;
					setSoftKeyboardEffectExplicitWidthFlag(false);
					setSoftKeyboardEffectExplicitHeightFlag(false);
					setSoftKeyboardEffectCachedHeight(NaN);
				}
			}*/
		}
		
		/**
		 *  @private
		 *  Start waiting for a (mouseDown, mouseUp) event sequence before effect
		 *  plays.
		 */
		/*private function setPendingSoftKeyboardEvent(event:SoftKeyboardEvent):void
		{
			softKeyboardEffectPendingEventType = event.type;
			
			// If the mouseDown event was already received, wait indefinitely
			// for mouseUp. If the soft keyboard event fired before mouseDown,
			// start a timer.
			if (!isMouseDown)
			{
				softKeyboardEffectPendingEventTimer = new Timer(softKeyboardEffectPendingEffectDelay, 1);
				softKeyboardEffectPendingEventTimer.addEventListener(TimerEvent.TIMER_COMPLETE, pendingEffectTimer_timerCompleteHandler);
				softKeyboardEffectPendingEventTimer.start();
			}
		}*/
		
		/**
		 *  @private
		 *  Listeners installed just before the soft keyboard effect makes changes
		 *  to the original position and height.
		 */
		private function installSoftKeyboardStateChangeListeners():void
		{/*
			if (!softKeyboardStateChangeListenersInstalled)
			{
				// Listen for mouseDown event on the pop-up and delay the soft
				// keyboard effect until mouseUp. This allows button click
				// events to complete normally before the button is re-positioned.
				// See SDK-31534.
				var sandboxRoot:UIComponent = systemManager.getSandboxRoot();
				addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
				
				// Listen for mouseUp events anywhere to play the effect. See SDK-31534.
				sandboxRoot.addEventListener(MouseEvent.MOUSE_UP,
					mouseHandler, true*/ /* useCapture */ /*);
				sandboxRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,
					systemManager_mouseUpHandler);
				
				// Listen for orientationChanging and orientationChange to suspend
				// pop-up changes until the orientation change is complete.
				// On iOS, the keyboard is deactivated after orientationChanging,
				// then immediately activated after orientationChange is complete.
				// On Android, the keyboard is deactivated after orientationChanging,
				// but not reactivated after orienationChange.
				// On QNX, the keyboard is not deactivated at all. The keyboard is
				// simply activated again after orientationChange.
				softKeyboardEffectOrientationChanging = false;
				
				var smStage:Stage = systemManager.stage;
				smStage.addEventListener("orientationChanging", stage_orientationChangingHandler);
				smStage.addEventListener("orientationChange", stage_orientationChangeHandler);
				
				softKeyboardStateChangeListenersInstalled = true;
			}*/
		}
		
		/**
		 *  @private
		 */
		private function uninstallSoftKeyboardStateChangeListeners():void
		{/*
			if (softKeyboardStateChangeListenersInstalled)
			{
				// Uninstall effect delay handling
				removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
				
				var sandboxRoot:UIComponent = systemManager.getSandboxRoot();
				sandboxRoot.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler, true*/ /* useCapture */ /*);
				sandboxRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, systemManager_mouseUpHandler);
				
				// Uninstall orientation change handling
				var smStage:Stage = systemManager.stage;
				smStage.removeEventListener("orientationChange", stage_orientationChangeHandler);
				smStage.removeEventListener("orientationChanging", stage_orientationChangeHandler);
				
				softKeyboardStateChangeListenersInstalled = false;
			}*/
		}
		
		/**
		 *  @private
		 *  Listeners installed during the phase after the initial activate effect
		 *  is complete and before the deactive effect starts.
		 */
		private function installActiveResizeListener():void
		{
			if (!resizeListenerInstalled)
			{
				// Flag size changes while the soft keyboard effect is active (but
				// not playing)
				addEventListener("explicitWidthChanged", resizeHandler);
				addEventListener("explicitHeightChanged", resizeHandler);
				resizeListenerInstalled = true;
			}
		}
		
		/**
		 *  @private
		 */
		private function uninstallActiveResizeListener():void
		{
			if (resizeListenerInstalled)
			{
				// Uninstall resize listener
				removeEventListener("explicitWidthChanged", resizeHandler);
				removeEventListener("explicitHeightChanged", resizeHandler);
				resizeListenerInstalled = false;
			}
		}
		
		/**
		 *  @private
		 *  Clear explicit size that remains after a Resize effect.
		 */
		mx_internal function softKeyboardEffectResetExplicitSize():void
		{
			// Only remove and restore listeners if they are currently installed.
			var installed:Boolean = resizeListenerInstalled;
			
			if (installed)
				uninstallActiveResizeListener();
			
			// Remove explicit settings if due to Resize effect
			if (!softKeyboardEffectExplicitWidthFlag)
				explicitWidth = NaN;
			
			if (!softKeyboardEffectExplicitHeightFlag)
				explicitHeight = NaN;
			
			if (installed)
				installActiveResizeListener();
		}
	}
}