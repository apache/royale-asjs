package org.apache.flex.net.url
{
    public final class URLRequest extends Object
    {
        public var url:String;
        public var data:Object;
        public var contentType:String = "application/x-www-form-urlencoded";
        
        public function URLRequest(url:String = null)
        {
            super();
            if(url != null)
            {
                this.url = url;
            }
            this.requestHeaders = [];
        }
        
        public function get requestHeaders():Array
        {
            return null;
        }
        
        public function set requestHeaders(value:Array) : void
        {
        }
        
    }
}

