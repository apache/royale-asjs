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
package org.apache.royale.html.beads.plugin
{
  import org.apache.royale.events.EventDispatcher;
  import org.apache.royale.core.IBead;
  import org.apache.royale.core.IStrand;
  import org.apache.royale.core.IUIBase;
  import org.apache.royale.core.IPopUpHost;
  import org.apache.royale.events.Event;
  import org.apache.royale.utils.UIUtils;
  import org.apache.royale.events.IEventDispatcher;
  import org.apache.royale.core.IParent;
  import org.apache.royale.core.IParentIUIBase;
  import org.apache.royale.core.UIBase;
  import org.apache.royale.utils.CSSUtils;
  import org.apache.royale.events.MouseEvent;
  import org.apache.royale.core.DispatcherBead;

  COMPILE::SWF
  {
    import flash.display.Shape;
  }

  public class ModalOverlay extends DispatcherBead
  {
    public function ModalOverlay()
    {
      super();
    }
    
    override public function set strand(value:IStrand):void
    {
        _strand = value;
        listenOnStrand("modalShown", handleShown);
        listenOnStrand("modalHidden", handleHidden);
    }
    
    /**
     *  The host component. 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     *  @royaleignorecoercion org.apache.royale.core.IUIBase
     */
    public function get host():IUIBase
    {
        return _strand as IUIBase;
    }
    // Application and View are both possible parents,
    // but there's no single interface for both that will work.
    private var hostParent:IParent;
    private var overlay:UIBase;
    /**
     *  @royaleignorecoercion Object
     */
    private function handleShown(ev:Event):void
    {
      hostParent = host.parent;
      var index:int = hostParent.getElementIndex(host);
      overlay = new UIBase();
      COMPILE::SWF
      {
        overlay.width = (hostParent as Object).width;
        overlay.height = (hostParent as Object).height;
  			var shape:Shape = new Shape();
	  		shape.graphics.beginFill(color,alpha);
		  	shape.graphics.drawRect(0, 0, overlay.width, overlay.height);
			  shape.graphics.endFill();
        overlay.addChild(shape);

      }

      COMPILE::JS
      {
        var style:CSSStyleDeclaration = overlay.element.style;
        style.position = "fixed";
        style.top = "0px";
        style.left = "0px";
        style.width = "100%";
        style.height = "100%";
        style.opacity = alpha;
        style.backgroundColor = CSSUtils.attributeFromColor(color);
      }
      hostParent.addElementAt(overlay,index);
      overlay.addEventListener(MouseEvent.CLICK,handleClick);
    }

    private function handleClick(ev:MouseEvent):void
    {
      ev.preventDefault();
      ev.stopImmediatePropagation();
      if(_hideOnClick)
      {
        var displayBead:IModalDisplay =  host.getBeadByType(IModalDisplay) as IModalDisplay;
        displayBead.hide();
      }
    }

    private function handleHidden(ev:Event):void
    {
      hostParent.removeElement(overlay);
    }

    private var _hideOnClick:Boolean = true;

    /**
     * If <code>hideOnClick</code> is true, the host will be closed when clicking
     *  on the overlay. default is true
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    public function get hideOnClick():Boolean
    {
    	return _hideOnClick;
    }

    public function set hideOnClick(value:Boolean):void
    {
    	_hideOnClick = value;
    }

    private var _color:uint = 0;

    /**
     * The color value of the overlay (default black)
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    public function get color():uint
    {
    	return _color;
    }

    public function set color(value:uint):void
    {
    	_color = value;
    }

    private var _alpha:Number = 0.5;

    /**
     * The alpha of the overlay in a value of 0 through 1 (default 0.5).
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    public function get alpha():Number
    {
    	return _alpha;
    }
    [Inspectable(category="General", defaultValue="0.5", minValue="0", maxValue="1.0")]
    public function set alpha(value:Number):void
    {
    	_alpha = value;
    }
  }
}