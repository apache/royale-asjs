package org.apache.flex.net
{
    public class HTTPUtils
    {
        public function HTTPUtils()
        {
        }
        static public function encodeUrlVariables(data:Object):String
        {
            if(!data)
                return "";
            var b:Array = [];
            var x:String;
            for(x in data)
            {
                b.push(encodeURI(x));
                b.push("=");
                b.push(encodeURI(data[x]));
                b.push("&");
            }
            if(b.length)
                b.pop()
            return b.join("");
        }

    }
}