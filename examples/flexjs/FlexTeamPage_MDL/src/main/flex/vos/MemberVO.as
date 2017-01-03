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
package vos {
    public class MemberVO {

        public function MemberVO(name:String,apacheID:String,photoURL:String,bio:String,twitter:String,linkedIn:String,facebook:String){
            this.name = name;
            this.apacheID = apacheID;
            this.photoURL = photoURL;
            this.bio = bio;
            this.twitter = twitter;
            this.linkedIn = linkedIn;
            this.facebook = facebook;
        }

        [Bindable] public var name:String;
        [Bindable] public var title:String;
        [Bindable] public var apacheID:String;
        [Bindable] public var photoURL:String;
        [Bindable] public var bio:String;
        [Bindable] public var twitter:String;
        [Bindable] public var linkedIn:String;
        [Bindable] public var facebook:String;
    }
}
