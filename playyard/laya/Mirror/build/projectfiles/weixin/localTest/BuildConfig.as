//构建时，该配置会被构建脚本自动覆盖，可以本地修改该文件
package plat
{
    public class BuildConfig
	{
        public const gamename:String = "刀剑决";

        public const platid:int = 0;
        public const pf:String = PlatConst.QATest;

        public const svrurl:String = "http://106.75.130.99/37wan/mobile/h5_neiwang_";
        public const svrips:Array = [];
        public const svripfmt:String = "http://{0}/37wan/mobile/h5_neiwang_";

        public const resurl:String = "";

        public const defines: String = "DEVELOP;TESTUIN";
		
		public const fyReportUrl: String;
    }
}