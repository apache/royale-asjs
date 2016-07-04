package org.apache.flex.net.url
{
    public final class URLRequest extends Object
    {
        
        private static const kInvalidParamError:uint = 2004;
        private var _url:String;
        private var _data:Object;
        private var _contentType:String = "application/x-www-form-urlencoded";
        
        public function URLRequest(url:String = null)
        {
            super();
            if(url != null)
            {
                this.url = url;
            }
            this.requestHeaders = [];
        }
        
        public function get contentType():String
        {
            return _contentType;
        }

        public function set contentType(value:String):void
        {
            _contentType = value;
        }

        public function get data():Object
        {
            return _data;
        }

        public function set data(value:Object):void
        {
            _data = value;
        }

        public function get url() : String{
            return _url;
        }
        
        public function set url(param1:String) : void{
            _url = param1;
        }
        
        public function get requestHeaders() : Array { return null; };
        
        public function set requestHeaders(value:Array) : void
        {
            //if(value != null)
            //{
            //this.setRequestHeaders(value.filter(this.filterRequestHeaders));
            //}
            //else
            //{
            //this.setRequestHeaders(value);
            //}
        }
        
    }
}

