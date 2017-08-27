package org.apache.flex.html
{
    COMPILE::JS
    {
        import org.apache.flex.core.UIBase;
        import org.apache.flex.core.WrappedHTMLElement;
    }

    /**
     * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
     */
    COMPILE::JS
    public function addElementToWrapper(wrapper:UIBase,type:String):WrappedHTMLElement
    {
        var elem:WrappedHTMLElement = document.createElement(type) as WrappedHTMLElement;
			wrapper.positioner = wrapper.element = elem;
			elem.flexjs_wrapper = wrapper;
            return elem;
    }
}