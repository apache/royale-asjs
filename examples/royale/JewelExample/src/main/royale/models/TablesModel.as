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
	import org.apache.royale.collections.ArrayList;

	public class TablesModel 
	{
		private var _guitarrists:ArrayList = new ArrayList([
			{guitarrist: "Steve Vai", album: "Passion & Warfare", year: "1990"},
			{guitarrist: "Joe Satriani", album: "Surfing With The Alien", year: "1987"},
			{guitarrist: "Yngwie Malmsteen", album: "Rising Force", year: "1984"},
			{guitarrist: "Steve Morse", album: "Southern Steel", year: "1991"},
			{guitarrist: "Mark Knopfler", album: "Local Hero", year: "1983"},
			{guitarrist: "Eric Sardinas", album: "Treat Me Right", year: "1999"},
			{guitarrist: "Mike Oldfield", album: "Tubular Bells", year: "1973"},
			{guitarrist: "Van Halen", album: "1984", year: "1984"}
		]);
		
		public function get guitarrists():ArrayList
		{
			return _guitarrists;
		}
	}
}
