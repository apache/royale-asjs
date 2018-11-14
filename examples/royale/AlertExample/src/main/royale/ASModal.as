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
package
{
  import org.apache.royale.html.VContainer;
  import org.apache.royale.html.beads.plugin.ModalDisplay;
  import org.apache.royale.html.beads.plugin.ModalOverlay;
  import org.apache.royale.html.Label;
  import org.apache.royale.html.TextButton;
  import org.apache.royale.events.MouseEvent;

  public class ASModal extends VContainer
  {
    public function ASModal()
    {
      super();
      this.style = {"backgroundColor":"#FFFFFF"};
      _modal = new ModalDisplay();
      _modal.maxWidth = 600;
      addBead(_modal);
      var overlay:ModalOverlay = new ModalOverlay();
      overlay.hideOnClick = true;
      addBead(overlay);
      this.height = 300;
      var text:Label = new Label();
      text.text = "Just a Modal";
      addElement(text);
      var close:TextButton = new TextButton();
      close.text = "Close";
      close.addEventListener(MouseEvent.CLICK,function(ev:MouseEvent):void{_modal.hide()});
      addElement(close);
    }
    private var _modal:ModalDisplay;

    public function get modal():ModalDisplay
    {
    	return _modal;
    }
  }
}