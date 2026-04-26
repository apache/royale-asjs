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
package org.apache.royale.style
{
  import org.apache.royale.core.IHasLabel;
  import org.apache.royale.debugging.assert;
  import org.apache.royale.style.elements.Div;
  import org.apache.royale.style.elements.Span;
  import org.apache.royale.style.skins.ITooltipSkin;
  import org.apache.royale.geom.Rectangle;
  
  COMPILE::JS {
    import org.apache.royale.core.WrappedHTMLElement;
  }
  
  public class Tooltip extends StyleUIBase implements IHasLabel
  {
    
    public function Tooltip(forDisplayInPopup:Boolean = false)
    {
      super();
      useWrapperStyle = true;
      _forDisplayInPopup = forDisplayInPopup;
      //set the default direction
      toggleAttribute("data-direction-top", true);
    }
    
    override public function getWrapperStyle():String{
      return 'tool-tip';
    }
    
    private var _forDisplayInPopup:Boolean;
    public function get forDisplayInPopup():Boolean{
        return _forDisplayInPopup
    }
  
    private var _contentNode:Div;
    /**
     * The container node for the tooltip message
     */
    public function get contentNode():Div{
      return _contentNode;
    }

    private var _labelNode:Span;
    /**
     * The label element within the content node
     */
    public function get labelNode():Span{
      return _labelNode;
    }

    private var _tipNode:Span;
    /**
     * The tip (arrow) element
     */
    public function get tipNode():Span{
      return _tipNode;
    }

    private var _text:String;

    public function get text():String
    {
    	return _text;
    }

    public function set text(value:String):void
    {
      if(_text != value){
        _text = value;
        if(_labelNode) _labelNode.text = value;
      }
    }

    public function get label():String {
      return text;
    }
    
    public function set label(value:String):void {
      text = value;
    }

    private var _flavor:String;

    /**
     * The flavor of the Tooltip
     * One of info, positive and negative, success and error.
     * To set the Tooltip to the default, specify an empty string
     * for each of the known categories, an icon is shown by default, 
     * unless the separate icon property is set to 'none'
     */
    public function get flavor():String
    {
    	return _flavor;
    }

    [Inspectable(category="General", enumeration="info,positive,negative,success,error")]
    public function set flavor(value:String):void
    {
      if(value != _flavor){
        switch(value){
          case "info":
          case "positive":
          case "negative":
          case "success":
          case "error":
          case "":
            break;
          default:
            throw new Error("Unknown flavor: " + value);
        }
        _flavor = value;
        if (skin) {
          updateFlavorIcon();
        }
      }
    }
    
    
    private var _icon:String = '';
    /**
     * Icon to display, which can override the default icon selected by 'flavor'. One of: info, success, alert, help, none
     * Default is no value.
     * if not set, then the flavor will dictate a default icon. Otherwise, this setting takes precedence
     */
    public function get icon():String
    {
      return _icon;
    }
    
    [Inspectable(category="General", enumeration="info,success,alert,help,none")]
    public function set icon(value:String):void
    {
      value = value || '';
      if (value != _icon) {
        _icon = value;
        if (skin) {
          updateFlavorIcon();
        }
      }
    }
    

    private var _flavorIcon:IStyleUIBase;

    private function updateFlavorIcon():void{
      if (_flavorIcon) {
        _contentNode.removeElement(_flavorIcon);
      }
      var tooltipSkin:ITooltipSkin = skin as ITooltipSkin;
      if (tooltipSkin) {
        var flavor:String = _icon || _flavor;
        _flavorIcon = tooltipSkin.getIcon(flavor);
        if (_flavorIcon) {
          _contentNode.addElementAt(_flavorIcon, 0);
        }
      }
    }

    private var _direction:String = 'top';

    public function get direction():String
    {
    	return _direction;
    }

    [Inspectable(category="General", enumeration="left,right,bottom,top", defaultValue="top")]
    public function set direction(value:String):void
    {
      if (value == _direction) return;
      if(_direction){
        toggleAttribute("data-direction-" + _direction, false);
      }
      if(value){
        switch(value){
          case "left":
          case "right":
          case "bottom":
          case "top":
            toggleAttribute("data-direction-" + value, true);
            break;
          default:
            throw new Error("Invalid direction: " + value);
        }
      }
      _direction = value;
      positionTip();
    }

    private var _tipPosition:String = "center";
    /**
     * The position of the tip within the tooltip
     */
    public function get tipPosition():String{
    	return _tipPosition;
    }

    [Inspectable(category="General", enumeration="start,end,center")]
    public function set tipPosition(value:String):void{
      if(value == _tipPosition){
        return;
      }
      switch(value){
        case "start":
        case "end":
        case "center":
          _tipPosition = value;
          break;
        default:
          _tipPosition = "center";
          break;
      }
      positionTip();
    }

    private function positionTip():void{
      if (skin) {
        _tipNode.setStyles(( skin as ITooltipSkin).tipStyles, true);
      }
    }

    private var _isOpen:Boolean = false;

    public function get isOpen():Boolean
    {
    	return _isOpen;
    }

    public function set isOpen(value:Boolean):void
    {
      if(value != _isOpen){
        toggleAttribute("is-open", value);
      }
      _isOpen = value;
    }

    COMPILE::JS
    override protected function createElement():WrappedHTMLElement{
      var elem:WrappedHTMLElement = super.createElement();
      _contentNode = new Div();
      _labelNode = new Span();
      if(_text) _labelNode.text = _text;
      _contentNode.addElement(_labelNode);
      _tipNode = new Span();
      
      elem.appendChild(_contentNode.element);
      elem.appendChild(_tipNode.element);
      return elem;
    }

    override protected function applySkin():void{
      var tooltipSkin:ITooltipSkin = skin as ITooltipSkin;
      assert(tooltipSkin is ITooltipSkin, "Tooltip requires a skin that implements ITooltipSkin");
      
      _contentNode.setStyles(tooltipSkin.tooltipContentStyles, true);
      _tipNode.setStyles(tooltipSkin.tipStyles, true);
      
      updateFlavorIcon();
      positionTip();
    }
    
    public function getFullHeight():Number{
      var h:Number = height;
      if (skin) {
        h += (skin as ITooltipSkin).getExtraHeight();
      }
      return h;
    }
    
    public function getFullHWidth():Number{
      var w:Number = width;
      if (skin) {
        w += (skin as ITooltipSkin).getExtraWidth();
      }
      return w;
    }
  }
}
