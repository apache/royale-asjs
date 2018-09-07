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
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.core.EdgeMetrics;
	import mx.core.LayoutContainer;
	import mx.core.ScrollPolicy;
	import mx.effects.Resize;
	import mx.events.ResizeEvent;
	
    [Style(name="openDuration", type="Number", format="Time", inherit="no")]
    [Style(name="closeDuration", type="Number", format="Time", inherit="no")]
    [Style(name="headerTextAlign", type="String", inherit="no")]

    public class MultiPanel extends LayoutContainer {

		[Embed (source="assets/header_close_icon.png")]
		private static var ICON_CLOSE:Class;
		
		[Embed (source="assets/header_open_icon.png")]
		private static var ICON_OPEN:Class;
		
		private static var SPACING_TOP:uint = 10;
		private static var SPACING_BOTTOM:uint = 5;
		private var _headerButton:Button = null;
		private var _openedChanged:Boolean = false;
		private var _opened:Boolean = true;
		private var _viewMetrics:EdgeMetrics;
		private var resize:Resize;

		public function MultiPanel() {
			super();

			this.verticalScrollPolicy = ScrollPolicy.OFF;
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
			
			addEventListener("PropertyEditorChanged", onPropertyEditorChange);
 		}

        protected function createOrReplaceHeaderButton():void {
           if(_headerButton) {
                _headerButton.removeEventListener(MouseEvent.CLICK, headerButton_clickHandler);
                
                if(rawChildren.contains(_headerButton))
                    rawChildren.removeChild(_headerButton);
            }
            
       	 	_headerButton = new Button();
            applyHeaderButtonStyles(_headerButton);
            _headerButton.addEventListener(MouseEvent.CLICK, headerButton_clickHandler);
            rawChildren.addChild(_headerButton);
        }

        protected function applyHeaderButtonStyles(button:Button):void {
            button.setStyle("textAlign", getStyle("headerTextAlign"));
           	button.styleName = "multiPanelHeader";
            button.height = getStyle("headerHeight");
            button.label = label;
			
            if(_opened)
                button.setStyle('icon', ICON_OPEN);
            else
                button.setStyle('icon', ICON_CLOSE);
        }

        override public function set label(value:String):void {
            super.label = value;
            if(_headerButton) _headerButton.label = value;
        }

        public function get opened():Boolean {
            return _opened;
        }
        
        [Bindable]
        public function set opened(value:Boolean):void {
            var old:Boolean = _opened;
            
            _opened = value;
            _openedChanged = _openedChanged || old != _opened;
           
            if(_openedChanged && initialized) {
                measure();
               	runResizeEffect();
                
                invalidateProperties();
            }
        }

        override public function styleChanged(styleProp:String):void {
            super.styleChanged(styleProp);
            
            if(styleProp == "headerTextAlign") {
                applyHeaderButtonStyles(_headerButton);
            }
            
            invalidateDisplayList();
        }

        override protected function createChildren():void {
            super.createChildren();
         
            createOrReplaceHeaderButton();
        }

        override protected function commitProperties():void {
			super.commitProperties();
						
            if(_openedChanged) {
                if(_opened)
                    _headerButton.setStyle('icon', ICON_OPEN);
                else
                    _headerButton.setStyle('icon', ICON_CLOSE);
                
                _openedChanged = false;
            }
        }

        override protected function updateDisplayList(w:Number, h:Number):void {
            super.updateDisplayList(w, h);
            
			_headerButton.move(0,0);
			_headerButton.setActualSize(w, _headerButton.getExplicitOrMeasuredHeight());
        }

		override public function get viewMetrics():EdgeMetrics {
	        if (!_viewMetrics)
	            _viewMetrics = new EdgeMetrics(0, 0, 0, 0);
	        
	        var edgeMetrics:EdgeMetrics = _viewMetrics;
	        var parentEdgeMetrics:EdgeMetrics = super.viewMetrics;
	        
	        edgeMetrics.left = parentEdgeMetrics.left;
	        edgeMetrics.top = parentEdgeMetrics.top + SPACING_TOP;
	        edgeMetrics.right = parentEdgeMetrics.right;
	        edgeMetrics.bottom = parentEdgeMetrics.bottom + SPACING_BOTTOM;
	        
	        var headerHeight:Number = _headerButton.getExplicitOrMeasuredHeight();
	        if (!isNaN(headerHeight)) {
	        	edgeMetrics.top += headerHeight;
	        }

	        return edgeMetrics;
    	}

        override protected function measure():void {
            super.measure();
            
            if(!_opened) {
            	//only the height of the header button
            	measuredHeight = _headerButton.getExplicitOrMeasuredHeight();
            }
        }
		
        protected function runResizeEffect():void {
			if(resize && resize.isPlaying)
				resize.end();
			
            var duration:Number = _opened ? getStyle("openDuration") : getStyle("closeDuration");
            if(duration == 0) { 
            	this.setActualSize(getExplicitOrMeasuredWidth(), measuredHeight);
            	
            	invalidateSize();
            	invalidateDisplayList();
            }
            else {
	            resize = new Resize(this);
	            resize.heightTo = Math.min(maxHeight, measuredHeight);
	            resize.duration = duration;
	            resize.play();
	        }
	    }

        protected function headerButton_clickHandler(event:MouseEvent):void {
            opened = !_opened;
        }
 		
 		private function onPropertyEditorChange(event:Event):void {
 			// Make sure that the panel exists and is open before doing anything
            if(initialized && _opened) {
                measure();
               	runResizeEffect();
                invalidateProperties();
            }
 		}
     }
}
