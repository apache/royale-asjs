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
  import org.apache.royale.core.DispatcherBead;

  public class ModalDisplay extends DispatcherBead implements IModalDisplay
  {
    public function ModalDisplay()
    {
      super();
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

    /**
     * Shows the host in a popup host
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    public function show(parent:IPopUpHost):void
    {
      COMPILE::JS
      {
        var elem:HTMLElement = host.element;
        elem.style.position = "fixed";
        elem.style.left = "50%";
        elem.style.maxWidth = "100%";
        elem.style.maxHeight = "100%";
        if(_maxWidth)
          elem.style.width = "" + _maxWidth + "px";

        switch(_position)
        {
          case "top":
            elem.style.top = "0px";
            elem.style.transform = "translate(-50%)";
            break;
          case "bottom":
            elem.style.transform = "translate(-50%)";
            //TODO calculate bottom
            break;
          default:
            elem.style.top = "50%";
            elem.style.transform = "translate(-50%, -50%)";
        }

      }
      parent.popUpParent.addElement(host);
      COMPILE::SWF
      {
        var parentComp:Object = parent;
        if(!isNaN(_maxWidth))
          host.width = _maxWidth;
        if(host.width > parentComp.width)
          host.width = parentComp.width;

        host.x = (parentComp.width - host.width) / 2;
        switch(_position){
          case "top":
            host.y = 0;
            break;
          case "bottom":
            host.y = parentComp.height - host.height;
            break;
          default:
            host.y = (parentComp.height - host.height) / 2;
            break;
        }
      }
      host.visible = true;
      host.dispatchEvent(new Event("modalShown"));
    }

    /**
     * Removes the host from the display list
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    public function hide():void
    {
      host.parent.removeElement(host);
      host.dispatchEvent(new Event("modalHidden"));
    }

    private var _position:String;

    /**
     * position can be "top", "bottom" or "center" (defaults to center)
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    private function get position():String
    {
    	return _position;
    }

    private function set position(value:String):void
    {
    	_position = value;
    }

    private var _maxWidth:Number;

    public function get maxWidth():Number
    {
    	return _maxWidth;
    }

    public function set maxWidth(value:Number):void
    {
    	_maxWidth = value;
    }
  }
}