package avatar.component {
	import flash.utils.Dictionary;
	import avatar.AvatarData;
	/**
	 * @author yangyiqiang
	 */
	public class AvatarMerge {
		
		public static function merge(data1:AvatarData,data2:AvatarData,config:Dictionary):AvatarData
		{
			if(!data1||!data2)return null;
			return data1.merge(data2,config);
		}
	}
}
