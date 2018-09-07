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
	import vos.GuitarristVO;

	[Bindable]
	public class TablesModel 
	{
		private var _guitarrists:ArrayList = new ArrayList([
			new GuitarristVO("Steve Vai", "Passion & Warfare", 1990),
			new GuitarristVO("Joe Satriani", "Surfing With The Alien", 1987),
			new GuitarristVO("Yngwie Malmsteen", "Rising Force", 1984),
			new GuitarristVO("Steve Morse", "Southern Steel", 1991),
			new GuitarristVO("Mark Knopfler", "Local Hero", 1983),
			new GuitarristVO("Eric Sardinas", "Treat Me Right", 1999),
			new GuitarristVO("Mike Oldfield", "Tubular Bells", 1973),
			new GuitarristVO("Van Halen", "1984", 1984)
		]);
		
		public function get guitarrists():ArrayList
		{
			return _guitarrists;
		}
	}
}
