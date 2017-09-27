package org.apache.flex.core
{
    COMPILE::SWF
    {
        import flash.display.BitmapData;
        import flash.display.DisplayObject;
        import flash.display.Bitmap;
    }

    /**
     *  The UIElement class Takes an IRenderedObject and creates a new UIBase
     *  which has the *appearance* of the original object.
     *  It *does not* have any of the orginal object's functionality.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.9
     */
    
    public class Lookalike extends UIBase
    {
        /**
         *  Constructor.
         *  
         *  @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.9
         */
        public function Lookalike(original:IRenderedObject)
        {
            COMPILE::SWF
            {
                var dObj:DisplayObject = original.$displayObject;
    			var bd:BitmapData = new BitmapData(dObj.width,dObj.height);
	    		bd.draw(dObj);
                addChild(new Bitmap(bd));
            }
            COMPILE::JS
            {
                element = original.element.cloneNode(true) as WrappedHTMLElement;
            }
            super();
        }
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            return element;
        }
    }
}