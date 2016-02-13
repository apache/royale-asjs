package flex.system
{
	import flash.system.Capabilities;
	
	public class I18NManager
	{
		public function I18NManager()
		{
		}
		
		public static function get languages():Array
		{
			COMPILE::AS3
			{
				// Capabilities.languages was added in AIR 1.1,
				// so this API may not exist.
				if (Capabilities["languages"])
					return Capabilities["languages"];
				else
					return [ Capabilities.language ];
			}
		}
	}
}