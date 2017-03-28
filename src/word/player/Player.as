package word.player {
	import avatar.AnimationController;
	import avatar.Asset;
	import avatar.Avatar;
	import avatar.AvatarData;
	import avatar.component.AvatarMerge;
	import avatar.component.AvatarName;
	import avatar.component.Ride;
	import avatar.component.Wing;

	import word.GameObj;
	import word.controller.LayerController;
	/**
	 * @author yangyiqiang
	 */
	public class Player extends GameObj{
		public var avatar:Avatar;
		public var avatarName:AvatarName;
		public var ride:Ride;
		public var wing:Wing;
		public var animationController:AnimationController;
		public var layerController:LayerController;
		
		
		public function set body(value:Avatar):void
		{
			avatar=value;
			layerController=new LayerController(this);
		}
		
		public function get body():Avatar
		{
			return avatar;
		}
		
		public function setName(value:String):void
		{
			if(!avatarName)avatarName=new AvatarName(body);
			avatarName.setName(value);
		}
		
		public function merge():void
		{
			var data:AvatarData=AvatarMerge.merge(body.animation.data, wing.wingAvatar.animation.data,wing.wingConfig.getWingDic("1"));
			General.assetsPool.set(data.key, data);
			removeWing(wing);
			var asset:Asset=new Asset(data.key);
			asset.state=Asset.ASSEST_DATA;
			body.resetAsset(asset);
		}
		
		public function addWing(value:Wing):void
		{
			if(wing)removeWing(wing);
			wing=value;
			body.body.addChild(value.wingAvatar);
		}
		
		public function removeWing(value:Wing):void
		{
			value.reset();
		}
		
		public function addRide(value:Ride):void
		{
			if(ride)removeRide(ride);
			ride=value;
			body.body.addChild(value.rideAvatar);
		}
		
		public function removeRide(value:Ride):void
		{
			value.reset();
			value=null;
		}
	}
}
