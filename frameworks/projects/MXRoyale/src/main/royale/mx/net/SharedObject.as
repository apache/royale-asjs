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

package mx.net
{

COMPILE::SWF
{
    import flash.net.SharedObject;
}
 
import org.apache.royale.events.EventDispatcher;
import org.apache.royale.utils.string.trim;
 


public class SharedObject extends org.apache.royale.events.EventDispatcher
{
    public static function getLocal(name:String, localPath:String = null, secure:Boolean = false):mx.net.SharedObject
	{
        var so:mx.net.SharedObject = new mx.net.SharedObject();
        so.setName(name);
        so.setLocalPath(localPath);
        COMPILE::SWF
        {
            so.createSO();        
        }
        return so;
    }
    
    COMPILE::SWF
    private var _so:flash.net.SharedObject;
      
      public function flush(minDiskSpace:int = 0):String
	  {
	        COMPILE::JS
            {
                if (_data)
                {
                    var theseKeys:Object = {};
                    for (var p:String in _data)
                    {
                        document.cookie = _name + p + '=' + _data[p];
                        theseKeys[p] = 1;
                    }
                    var deleteKeys:Array = [];
                    for (p in keys)
                    {
                        if (!theseKeys[p])
                        {
                            deleteKeys.push(p);
                        }
                    }
                    for each (p in deleteKeys)
                    {
                        delete keys[p];
                        document.cookie = _name + p + '=; expires=Thu, 01 Jan 1970 00:00:00 GMT';
                    }
                }
                return SharedObjectFlushStatus.FLUSHED;
            }
            COMPILE::SWF
            {
                return _so.flush(minDiskSpace);
            }
	  }

      private var keys:Object = {};
      
      private var _data:Object;
      
      public function get data():Object
	  {
	       COMPILE::SWF
           {
               return _so.data;
           }
           COMPILE::JS
           {
               if (!_data)
               {
                   _data = {};
                   var allCookies:String = String(document.cookie);
                   var arrCookies:Array = allCookies.split(';');
                   for each (var s:String in arrCookies)
                   {
                       s = trim(s);
                       var parts:Array = s.split('=');
                        if (parts[0].indexOf(_name) == 0)
                        {
                            var key:String = parts[0].substring(_name.length);
                            keys[key] = 1;
                            _data[key] = parts[1];
                        }
                   }
               }
               return _data;
           }
	  }
      
      private var _name:String;
      
      public function setName(name:String):void
      {
          _name = name;
      }
      
      private var _localPath:String;
      
      public function setLocalPath(localPath:String):void
      {
          _localPath = localPath;
      }
      
      COMPILE::SWF
      public function createSO():void
      {
          _so = flash.net.SharedObject.getLocal(_name, _localPath);
      }
   }

            

}
