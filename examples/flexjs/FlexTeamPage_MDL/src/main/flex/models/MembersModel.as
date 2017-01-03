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
package models
{
import org.apache.flex.events.Event;
import org.apache.flex.events.EventDispatcher;
import org.apache.flex.html.TextNode;
import org.apache.flex.net.HTTPService;

import vos.MemberVO;

[Event(name="membersChanged", type="org.apache.flex.events.Event")]

public class MembersModel extends EventDispatcher
{

    private var _members:Array = [];

    public function MembersModel() {
        loadMembers();
    }

    protected function loadMembers():void {
        var httpService:HTTPService = new HTTPService();
        httpService.url = 'http://flex.apache.org/team/team.json';
        httpService.addEventListener("complete", handleLoadComplete);
        httpService.addEventListener("ioError", handleError);
        httpService.send();
    }

    protected function handleLoadComplete(event:Event):void
    {
        var responseStr:String = event.target._element.response;
        //Remove the comments
        responseStr = responseStr.substr(responseStr.indexOf('{'),responseStr.length);
        var response:Object = JSON.parse(responseStr);
        createMemberVOs(response.members);
    }

    protected function handleError(event:Event):void
    {
        trace('Error loading team.json from http://flex.apache.org/team/team.json');
    }

    protected function createMemberVOs(membersArr:Array):void {
        var v:Array = membersArr.map(function(memberObj):MemberVO {
            return new MemberVO(memberObj.name,memberObj.apacheID,memberObj.photoURL,memberObj.bio,memberObj.twitter,memberObj.linkedIn,memberObj.facebook);
        });
        this.members = v;
    }


    public function set members(v:Array):void {
        _members = v;
        dispatchEvent( new Event("membersChanged") );
        var t:TextNode = new TextNode();
    }

    public function get members():Array
    {
        return _members;
    }

}
}
