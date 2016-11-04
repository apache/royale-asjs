package models
{
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;

	public class Person extends EventDispatcher
	{
		private var _name:String;
		private var _apacheID:String;
		private var _title:String;
		private var _bio:String;
		private var _photoURL:String;
		private var _url:String;
		private var _social:Object;

		public function Person()
		{
			super();
			_social = {};
		}

		[Bindable("nameChanged")]
		public function get name():String
		{
			return _name;
		}
		public function set name(value:String):void
		{
			if (value != _name) {
				_name = value;
				dispatchEvent(new Event("nameChanged"));
			}
		}

		[Bindable("titleChanged")]
		public function get title():String
		{
			return _title;
		}
		public function set title(value:String):void
		{
			if (value != _title) {
				_title = value;
				dispatchEvent(new Event("titleChanged"));
			}
		}

		[Bindable("apacheIDChanged")]
		public function get apacheID():String
		{
			return _apacheID;
		}
		public function set apacheID(value:String):void
		{
			if (value != _apacheID) {
				_apacheID = value;
				dispatchEvent(new Event("apacheIDChanged"));
			}
		}

		[Bindable("bioChanged")]
		public function get bio():String
		{
			return _bio;
		}
		public function set bio(value:String):void
		{
			if (_bio != value) {
				_bio = value;
				dispatchEvent(new Event("bioChanged"));
			}
		}

		[Bindable("photoURLChanged")]
		public function get photoURL():String
		{
			return _photoURL;
		}
		public function set photoURL(value:String):void
		{
			if (_photoURL != value) {
				_photoURL = value;
				dispatchEvent(new Event("photoURLChanged"));
			}
		}

		[Bindable("urlChanged")]
		public function get url():String
		{
			return _url;
		}
		public function set url(value:String):void
		{
			if (_url != value) {
				_url = value;
				dispatchEvent(new Event("urlChanged"));
			}
		}
		
		public function addToSocial(type:String, url:String):void
		{
			_social[type] = url;
		}
		
		public function get social():Object
		{
			return _social;
		}
	}
}
