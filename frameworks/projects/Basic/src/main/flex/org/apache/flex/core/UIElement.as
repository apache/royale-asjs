package org.apache.flex.core
{
    /**
     *  The UIElement class is an HTML-only class which creates a UIBase wrapper around an HTML element.
     *  The constructor accepts an HTMLElement and swallows the standard createElement call.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.9
     */
    COMPILE::JS
    public class UIElement extends UIBase
    {
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.9
         */
        public function UIElement(htmlElement:WrappedHTMLElement)
        {
            element = htmlElement;
            super();
        }
        override protected function createElement():WrappedHTMLElement
        {
            return element;
        }
    }
}