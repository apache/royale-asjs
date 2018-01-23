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
package org.apache.royale.textLayout.elements
{
	import org.apache.royale.core.BrowserWindow;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.events.FlowElementMouseEventManager;
	import org.apache.royale.textLayout.events.ModelChange;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;

	/** 
	 * Dispatched when the mouse is pressed down over a link.
	 * @eventType org.apache.royale.textLayout.events.FlowElementMouseEvent.MOUSE_DOWN
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	[Event(name="mouseDown", type="org.apache.royale.textLayout.events.FlowElementMouseEvent")]
	/** 
	 * Dispatched when the mouse is released over a link. 
	 * @eventType org.apache.royale.textLayout.events.FlowElementMouseEvent.MOUSE_UP
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	[Event(name="mouseUp", type="org.apache.royale.textLayout.events.FlowElementMouseEvent")]
	/** 
	 * Dispatched when the mouse passes over the link. 
	 * @eventType org.apache.royale.textLayout.events.FlowElementMouseEvent.MOUSE_MOVE
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	[Event(name="mouseMove", type="org.apache.royale.textLayout.events.FlowElementMouseEvent")]
	/**
	 * Dispatched when the mouse first enters the link. 
	 * @eventType org.apache.royale.textLayout.events.FlowElementMouseEvent.ROLL_OVER
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	[Event(name="rollOver", type="org.apache.royale.textLayout.events.FlowElementMouseEvent")]
	/** 
	 * Dispatched when the mouse goes out of the link. 
	 * @eventType org.apache.royale.textLayout.events.FlowElementMouseEvent.ROLL_OUT
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	[Event(name="rollOut", type="org.apache.royale.textLayout.events.FlowElementMouseEvent")]
	/** 
	 * Dispatched when the link is clicked. 
	 * Clients may override how the link handles the event by handling it themselves, and calling preventDefault().
	 * @eventType org.apache.royale.textLayout.events.FlowElementMouseEvent.CLICK
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	[Event(name="click", type="org.apache.royale.textLayout.events.FlowElementMouseEvent")]
	/** The LinkElement class defines a link to a URI (Universal Resource Identifier), which is executed when the user clicks it.
	 * The LinkElement class is a subclass of the SubParagraphGroupElementBase class and it can contain
	 * one or more FlowElement objects, such as a SpanElement object that stores the link text. An empty
	 * LinkElement, which does not contain a FlowElement object, is ignored. 
	 * 
	 * <p>Normally when clicked the LinkElement will call the <code>flash.net.navigateToURL()</code> method.  A special URI scheme <code>event:</code>
	 * is also supported.  This scheme will generate a ITextFlow event that the user may listen to in order to execute AS3 code.  An example is included below.</p>
	 * 
	 * <p>If you specify a target, it must be one of the following values:
	 * <table class="innertable" width="100%">
	 * <tr>
	 *   <th>Target value</th> 
	 *   <th>description</th>
	 * </tr>
	 * <tr>
	 *   <td>_self</td>
	 *   <td>Replaces the current HTML page. If it is in a frame or frameset, it will load within that frame. If it is
	 *       the full browser, it opens to replace the page from which it came.</td>
	 * </tr>
	 * <tr>
	 *   <td>_blank</td>
	 *   <td>Opens a new browser name with no name.</td>
	 * </tr>
	 * <tr>
	 *   <td>_parent</td>
	 *   <td>Replaces the HTML page from which it came.</td>
	 * </tr>
	 * <tr>
	 *   <td>_top</td>
	 *   <td>Loads in the current browser, replacing anything within it, such as a frameset.</td>
	 * </tr>
	 * </table>
	 * </p>
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 * @see LinkState
	 * @see FlowElement#linkActiveFormat FlowElement.linkActiveFormat
	 * @see FlowElement#linkHoverFormat FlowElement.linkHoverFormat
	 * @see FlowElement#linkNormalFormat FlowElement.linkNormalFormat
	 * @see ITextFlow
	 *
	 */
	public final class LinkElement extends SubParagraphGroupElementBase implements ILinkElement
	{
		private var _uriString:String;
		private var _targetString:String;
		private var _linkState:String;

		/** Constructor - creates a new LinkElement instance.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function LinkElement()
		{
			super();

			_linkState = LinkState.LINK;
		}

		override public function get className():String
		{
			return "LinkElement";
		}

		/** @private */
		public override function get precedence():uint
		{
			return 800;
		}

		/**
		 * @param type The type of event.
		 * @param listener The listener function that processes the event. This function must accept an event object 
		 * as its only parameter and must return nothing, as this example shows:
		 * <p><code>function(evt:Event):void</code></p>
		 * The function can have any name.
		 * @param useCapture Determines whether the listener works in the capture phase or the target 
		 * and bubbling phases. If <code>useCapture</code> is set to <code>true</code>, the  
		 * listener processes the event only during the capture phase and not in the target or 
		 * bubbling phase. If <code>useCapture</code> is <code>false</code>, the listener processes the event only
		 * during the target or bubbling phase. To listen for the event in all three phases, call 
		 * <code>addEventListener()</code> twice, once with <code>useCapture</code> set to <code>true</code>, 
		 * then again with <code>useCapture</code> set to <code>false</code>.
		 * @param priority 	The priority level of the event listener. Priorities are designated by a 32-bit integer. 
		 * 					The higher the number, the higher the priority. All listeners with priority <em>n</em> 
		 * 					are processed before listeners of priority <em>n-1</em>. If two or more listeners share 
		 * 					the same priority, they are processed in the order in which they were added. The default priority is 0. 
		 * @param useWeakReference Determines whether the reference to the listener is strong or weak. A strong 
		 * reference (the default) prevents your listener from being garbage-collected. A weak 
		 * reference does not. <p>Class-level member functions are not subject to garbage 
		 * collection, so you can set <code>useWeakReference</code> to <code>true</code> for 
		 * class-level member functions without subjecting them to garbage collection. If you set
		 * <code>useWeakReference</code> to <code>true</code> for a listener that is a nested inner 
		 * function, the function will be garbge-collected and no longer persistent. If you create 
		 * references to the inner function (save it in another variable) then it is not 
		 * garbage-collected and stays persistent.</p>
		 *
		 * @copy org.apache.royale.events.IEventDispatcher#addEventListener()
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			getEventMirror().addEventListener(type, listener, useCapture);
		}
//TODO
		// public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		// {
		// 	getEventMirror().addEventListener(type, listener, useCapture, priority, useWeakReference);
		// }

		/**
		 * @copy org.apache.royale.events.IEventDispatcher#dispatchEvent()
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function dispatchEvent(evt:Event):Boolean
		{
			if (!hasActiveEventMirror())
				return false;
			return _eventMirror.dispatchEvent(evt);
		}

		/**
		 * @copy org.apache.royale.events.IEventDispatcher#hasEventListener()
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function hasEventListener(type:String):Boolean
		{
			if (!hasActiveEventMirror())
				return false;
			return _eventMirror.hasEventListener(type);
		}

		/**
		 *
		 * @param type The type of event.
		 * @param listener The listener object to remove.
		 * @param useCapture Specifies whether the listener was registered for the capture phase or the target and bubbling phases. If the listener was registered for both the capture phase and the target and bubbling phases, two calls to <code>removeEventListener()</code> are required to remove both: one call with <code>useCapture</code> set to <code>true</code>, and another call with <code>useCapture</code> set to <code>false</code>. 
		 *
		 * @copy org.apache.royale.events.IEventDispatcher#removeEventListener().
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			if (hasActiveEventMirror())
				_eventMirror.removeEventListener(type, listener, useCapture);
		}

		/**
		 * @copy org.apache.royale.events.IEventDispatcher#willTrigger()
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		// public function willTrigger(type:String):Boolean
		// {
		// 	if (!hasActiveEventMirror())
		// 		return false;
		// 	return _eventMirror.willTrigger(type);
		// }

		// end of IEventDispatcher functions
		/** @private */
		override protected function get abstract():Boolean
		{
			return false;
		}

		/** @private */
		public override function get defaultTypeName():String
		{
			return "a";
		}

		/**
		 * The Uniform Resource Identifier (URI) associated with the LinkElement object.  The URI can be any URI 
		 * supported by the <code>flash.net.navigateToURL()</code> method. This property maps
		 * to the <code>request</code> parameter for that method.  
		 * 
		 * The URI may also be of the form <code>event:eventType</code>.  When clicked the ITextFlow will generate an event of type <code>eventType</code>.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see ../../../flash/net/package.html#navigateToURL() flash.net.navigateToURL()
		 */
		public function get href():String
		{
			return _uriString;
		}

		public function set href(newUriString:String):void
		{
			_uriString = newUriString;
			modelChanged(ModelChange.ELEMENT_MODIFIED, this, 0, textLength);
		}

		/**
		 * The Target value associated with the LinkElement. Possible values are "_self", "_blank",
		 * "_parent", and "_top". This value maps to the <code>window</code> parameter of the
		 * <code>flash.net.navigateToURL()</code> method.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see ../../../flash/net/package.html#navigateToURL() flash.net.navigateToURL()
		 */
		public function get target():String
		{
			return _targetString;
		}

		public function set target(newTargetString:String):void
		{
			_targetString = newTargetString;
			modelChanged(ModelChange.ELEMENT_MODIFIED, this, 0, textLength);
		}

		/**
		 * The current state of the link.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see LinkState
		 */
		public function get linkState():String
		{
			return _linkState;
		}

		/**
		 *  @private
		 *  @royaleignorecoercion org.apache.royale.textLayout.elements.LinkElement
		 */
		public override function shallowCopy(startPos:int = 0, endPos:int = -1):IFlowElement
		{
			if (endPos == -1)
				endPos = textLength;

			var retFlow:LinkElement = super.shallowCopy(startPos, endPos) as LinkElement;
			retFlow.href = href;
			retFlow.target = target;
			return retFlow;
		}

		/** @private */
		public override function mergeToPreviousIfPossible():Boolean
		{
			// In links the eventMirror exists.  TLF ignores that when merging.
			// The risk is that everything matches but the user has added a custom listener to the eventMirror.
			if (parent && !bindableElement)
			{
				var myidx:int = parent.getChildIndex(this);
				if (textLength == 0)
				{
					parent.replaceChildren(myidx, myidx + 1, null);
					return true;
				}

				if (myidx != 0 && !hasActiveEventMirror())
				{
					var sib:LinkElement = parent.getChildAt(myidx - 1) as LinkElement;
					if (sib != null && !sib.hasActiveEventMirror())
					{
						if ((this.href == sib.href) && (this.target == sib.target) && equalStylesForMerge(sib))
						{
							parent.removeChildAt(myidx);
							if (numChildren > 0)
								sib.replaceChildren(sib.numChildren, sib.numChildren, this.mxmlChildren);
							return true;
						}
					}
				}
			}
			return false;
		}

		/** 
		 * Specifies the name of the text format element of a LinkElement when the link is in the normal state.
		 * @private
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		static public const LINK_NORMAL_FORMAT_NAME:String = "linkNormalFormat";
		/** 
		 * Specifies the name of the text format element of a LinkElement when the link is in the active state. 
		 * @private
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		static public const LINK_ACTIVE_FORMAT_NAME:String = "linkActiveFormat";
		/** Specifies the name of the text format element of a LinkElement when the cursor is hovering over the link. 
		 * @private
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		static public const LINK_HOVER_FORMAT_NAME:String = "linkHoverFormat";

		private function computeLinkFormat(formatName:String):ITextLayoutFormat
		{
			var linkStyle:ITextLayoutFormat = getUserStyleWorker(formatName) as ITextLayoutFormat;
			if (linkStyle == null)
			{
				var tf:ITextFlow = getTextFlow();
				if (tf)
					linkStyle = tf.configuration["defaultL" + formatName.substr(1)];
			}

			return linkStyle;
		}

		/** 
		 * The state-dependent character attributes for the link.
		 * @private
		 */
		public function get effectiveLinkElementTextLayoutFormat():ITextLayoutFormat
		{
			var cf:ITextLayoutFormat;

			if (_linkState == LinkState.SUPPRESSED)
				return null;
			else if (_linkState == LinkState.ACTIVE)
			{
				cf = computeLinkFormat("linkActiveFormat");
				if (cf)
					return cf;
			}
			else if (_linkState == LinkState.HOVER)
			{
				cf = computeLinkFormat("linkHoverFormat");
				if (cf)
					return cf;
			}

			return computeLinkFormat("linkNormalFormat");
		}

		/** @private TODO: Possible optimization - replace this with prototype chaining?? */
		public override function get formatForCascade():ITextLayoutFormat
		{
			var superFormat:TextLayoutFormat = format as TextLayoutFormat;
			var effectiveFormat:ITextLayoutFormat = effectiveLinkElementTextLayoutFormat;
			if (effectiveFormat || superFormat)
			{
				if (effectiveFormat && superFormat)
				{
					var resultingTextLayoutFormat:TextLayoutFormat = new TextLayoutFormat(effectiveFormat);
					if (superFormat)
						resultingTextLayoutFormat.concatInheritOnly(superFormat);
					return resultingTextLayoutFormat;
				}
				return superFormat ? superFormat : effectiveFormat;
			}
			return null;
		}
		/** @private */
		CONFIG::debug
		public override function setParentAndRelativeStart(newParent:IFlowGroupElement, newStart:int):void
		{
			if (groupElement)
			{
				var groupTextLength:int = groupElement.rawText ? groupElement.rawText.length : null;
				assert(groupTextLength == this.textLength, "LinkElement - gc = " + this.groupElement.rawText + " this.textLength = " + this.textLength);
			}

			super.setParentAndRelativeStart(newParent, newStart);
		}

		/** @private */
		private function setToState(linkState:String):void
		{
			if (_linkState != linkState)
			{
				var oldCharAttrs:ITextLayoutFormat = effectiveLinkElementTextLayoutFormat;
				_linkState = linkState;
				var newCharAttrs:ITextLayoutFormat = effectiveLinkElementTextLayoutFormat;
				if (!(TextLayoutFormat.isEqual(oldCharAttrs, newCharAttrs)))
				{
					formatChanged(true);
					var tf:ITextFlow = getTextFlow();
					if (tf && tf.flowComposer)
						tf.flowComposer.updateAllControllers();
				}
			}
		}

		/** @private */
		public function chgLinkState(linkState:String):void
		{
			if (_linkState != linkState)
			{
				_linkState = linkState;
				formatChanged(false);
			}
		}

		/** @private
		 * The ElementMouseEventManager calls this method directly. Note that the mouse
		 * coordinates are unrelated to any coordinate in the container or this element.
		 */
		public function mouseDownHandler(mgr:FlowElementMouseEventManager, evt:MouseEvent):void
		{
			mgr.setHandCursor(true);
			setToState(LinkState.ACTIVE);
			evt.stopImmediatePropagation();
		}

		/** @private
		 * The ElementMouseEventManager calls this method directly. Note that the mouse
		 * coordinates are unrelated to any coordinate in the container or this element.
		 */
		public function mouseMoveHandler(mgr:FlowElementMouseEventManager, evt:MouseEvent):void
		{
			mgr.setHandCursor(true);
			setToState(evt.buttonDown ? LinkState.ACTIVE : LinkState.HOVER);
		}

		/** @private
		 * The ElementMouseEventManager calls this method directly. Note that the mouse
		 * coordinates are unrelated to any coordinate in the container or this element.
		 */
		public function mouseOutHandler(mgr:FlowElementMouseEventManager, evt:MouseEvent):void
		{
			mgr.setHandCursor(false);
			setToState(LinkState.LINK);
		}

		/** @private
		 * The ElementMouseEventManager calls this method directly. Note that the mouse
		 * coordinates are unrelated to any coordinate in the container or this element.
		 */
		public function mouseOverHandler(mgr:FlowElementMouseEventManager, evt:MouseEvent):void
		{
			mgr.setHandCursor(true);
			setToState(evt.buttonDown ? LinkState.ACTIVE : LinkState.HOVER);
		}

		/** @private
		 * The ElementMouseEventManager calls this method directly. Note that the mouse
		 * coordinates are unrelated to any coordinate in the container or this element.
		 */
		public function mouseUpHandler(mgr:FlowElementMouseEventManager, evt:MouseEvent):void
		{
			mgr.setHandCursor(true);
			setToState(LinkState.HOVER);
			evt.stopImmediatePropagation();
		}

		/** @private
		 * The ElementMouseEventManager calls this method directly. Note that the mouse
		 * coordinates are unrelated to any coordinate in the container or this element.
		 */
		public function mouseClickHandler(mgr:FlowElementMouseEventManager, evt:MouseEvent):void
		{
			if (_uriString != null)
			{
				if ((_uriString.length > 6) && (_uriString.substr(0, 6) == "event:"))
				{
					mgr.dispatchFlowElementMouseEvent(_uriString.substring(6, _uriString.length), evt);
				}
				else
				{
					BrowserWindow.open(_uriString, target);
					// var u:URLRequest = new URLRequest(encodeURI(_uriString));
					// flash.net.navigateToURL(u, target);
				}
			}
			evt.stopImmediatePropagation();
		}

		/** @private */
		public override function acceptTextBefore():Boolean
		{
			return false;
		}

		/** @private */
		public override function acceptTextAfter():Boolean
		{
			return false;
		}

		/** @private This is done so that the TextContainerManager can discover LinkElements in a ITextFlow. 
		 * Links don't use the mouseeventdispatcher for link related events - that's a bug that should be fixed.
		 * A link may increment the interactiveObjectCount twice - once as as Link and once if it has listeners attached via getEventMirror  */
		public override function appendElementsForDelayedUpdate(tf:ITextFlow, changeType:String):void
		{
			if (changeType == ModelChange.ELEMENT_ADDED)
			{
				tf.incInteractiveObjectCount();
				// This is to detect if current paragraph has interactive child
				getParagraph().incInteractiveChildrenCount() ;
			}
			else if (changeType == ModelChange.ELEMENT_REMOVAL)
			{
				tf.decInteractiveObjectCount();
				// This is to detect if current paragraph has interactive child
				getParagraph().decInteractiveChildrenCount() ;
			}
			super.appendElementsForDelayedUpdate(tf, changeType);
		}

		/** @private This API supports the inputmanager */
		public override function updateForMustUseComposer(textFlow:ITextFlow):Boolean
		{
			return true;
		}
	}
}
