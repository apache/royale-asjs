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
  import org.apache.royale.core.IPopUpHost;
  import org.apache.royale.debugging.assert;
  import org.apache.royale.style.elements.Div;
  import org.apache.royale.style.skins.IToastSkin;
  import org.apache.royale.utils.Timer;
  import org.apache.royale.events.Event;
  
  COMPILE::SWF{
    //compilation support only:
    import flash.utils.setTimeout;
  }
  
  COMPILE::JS
  {
    import org.apache.royale.core.WrappedHTMLElement;
  }
  
  [Event(name="accept", type="org.apache.royale.events.Event")]
  [Event(name="close", type="org.apache.royale.events.Event")]
  public class Toast extends StyleUIBase implements IHasLabel
  {

    
    public function Toast(content:String = null, autoClose:uint=0)
    {
      super();
      if(content){
        label = content;
      }
      this.autoClose = autoClose;
    }


    public static const INFO:String = "info";
    public static const NEGATIVE:String = "negative";
    public static const POSITIVE:String = "positive";
    public static const WARNING:String = "warning";
    public static const SUCCESS:String = "success";
    
    
    override public function addedToParent():void{
      //This should not be added to anything other than an IPopUpHost. 
      //In particular, fx:Declarations nodes in Royale don't work as they should for Visual components. They should not add to display, but they do.
      super.addedToParent();
      if (!(parent is IPopUpHost)) {
        parent.removeElement(this)
      }
    }
    
    private var _label:String = "";
    public function get label():String
    {
      return _label;
    }
    
    public function set label(value:String):void
    {
      COMPILE::JS
      {
        if(_label != value){
          _label = value;
          _contentNode.text = value;
        }
      }
    }
    
    private var actionButton:IStyleUIBase;
    private var _action:String;
    public function get action():String
    {
    	return _action;
    }
    
    public function set action(value:String):void
    {
      if (value != _action) {
        _action = value;
        updateActionButton();
      }
    }
    
    private function updateActionButton():void{
      if (actionButton) {
        actionButton.removeEventListener("click",onAction);
        body.removeElement(actionButton)
      }
      var toastSkin:IToastSkin = skin as IToastSkin;
      if (_action && toastSkin) {
        actionButton = toastSkin.getActionButton(_action);
        actionButton.addEventListener("click",onAction);
        body.addElement(actionButton)
      }
    }
    
    private function onAction(ev:Event):void{
      if(_shown){
        dispatchEvent(new Event("accept"));
      }
      hide();
    }

    private var _flavorIcon:IStyleUIBase;
    private var _flavor:String;
    public function get flavor():String
    {
    	return _flavor;
    }
    //"base","primary","secondary","accent","info","success","warning","error","neutral"
    [Inspectable(category="General", enumeration="info,success,positive,negative,warning")]
    /**
     * Set the flavor of the Toast
     * One of info, success, positive and negative. warning also appears to be an option
     * To set the Toast to the default, specify an empty string
     */
    public function set flavor(value:String):void
    {
      if(value != _flavor){
        switch(value){
          case "info":
          case "positive":
          case "success":
          case "negative":
          case "error":
          case "warning":
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
    
    private function updateFlavorIcon():void{
      if (_flavorIcon) {
        _body.removeElement(_flavorIcon);
      }
      var toastSkin:IToastSkin = skin as IToastSkin;
      _flavorIcon = toastSkin.getIcon(_flavor);
      if (_flavorIcon) {
        _body.addElementAt(_flavorIcon,0);
      }
    }

    private var timer:Timer;
    public function show():void{
      if(_shown){
        return;
      }
      _shown = true;
      toggleAttribute("data-hiding", false);
      toggleAttribute("data-showing", true);
      Application.current.popUpParent.addElement(this);
    }
    
    /**
     * @private
     * for use from skins when inbound animations are done
     */
    public function afterShow():void{
      if(autoClose){
        timer = new Timer(autoClose);
        timer.addEventListener(Timer.TIMER,onTimer)
        timer.start();
      }
    }

    private function onTimer(ev:Event):void{
      timer.removeEventListener(Timer.TIMER,onTimer);
      hide();
    }
    
    private var _shown:Boolean;
    public function hide():void{
      if(!_shown){
        return;
      }
      _shown = false;
      toggleAttribute("data-showing", false);
      toggleAttribute("data-hiding", true);
      dispatchEvent(new Event("close"));
    }
    
    /**
     * @private
     * for use from skins when outbound animations are done
     */
    public function afterHide():void{
      if (this.parent)
        Application.current.popUpParent.removeElement(this);
      toggleAttribute("data-showing", false);
      toggleAttribute("data-hiding", false);
    }
    
    private var _autoClose:uint = 0;

    /**
     * Number of milliseconds the Toast will remain open.
     * A value of 0 (default) will cause it to remain open until closed.
     */
    public function get autoClose():uint
    {
    	return _autoClose;
    }

    public function set autoClose(value:uint):void
    {
    	_autoClose = value;
    }
    
    private var _toast:Div;
    /**
     * The container node for all the visual content of the Toast message and its controls
     */
    public function get toast():Div{
      return _toast;
    }
    private var _body:Div;
    /**
     * The container node for the message with optional action UI control
     */
    public function get body():Div{
      return _body;
    }
    
    private var _contentNode:Div;
    /**
     * The message content container - for label property to populate with text content
     */
    public function get contentNode():Div{
      return _contentNode;
    }
    
    private var _buttons:Div;
    /**
     * The button container for the toast controls (explicit close button)
     */
    public function get buttons():Div{
      return _buttons;
    }
    
    COMPILE::JS
    override protected function createElement():WrappedHTMLElement{
      var elem:WrappedHTMLElement = super.createElement();
      _toast = new Div();
      _body = new Div();
      _contentNode = new Div();
      _body.addElement(_contentNode);
      _toast.addElement(_body)
      _buttons = new Div();
      _toast.addElement(_buttons);
      elem.appendChild(toast.element);
      return elem;
    }
    
    override protected function applySkin():void{
      var toastSkin:IToastSkin = skin as IToastSkin;
      assert(toastSkin is IToastSkin, "Toast requires a skin that implements IToastSkin");
      var styles:Array = toastSkin.toastContentStyles || [];
      _toast.setStyles(styles, true);
      styles = toastSkin.textLayoutStyles || [];
      _contentNode.setStyles(styles,true);
      styles = toastSkin.toastBodyStyles || [];
      _body.setStyles(styles,true);
      updateFlavorIcon();
      if (_action && !actionButton) {
        updateActionButton()
      }
      styles = toastSkin.buttonsLayoutStyles || [];
      _buttons.setStyles(styles,true);
      if (!_buttons.numElements) {
        var button:IStyleUIBase = toastSkin.getCloseButton()
        button.addEventListener("click",hide);
        _buttons.addElement(button);
      }
    }

  }
}