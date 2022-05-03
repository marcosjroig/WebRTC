using Newtonsoft.Json;
using System.IO;
using System.Web;

namespace WebRtc.BusinessLogic
{
    public static class AppConfigurationReader
    {
        public static AppConfiguration ReadJson()
        {
            var serverPath = HttpContext.Current.Server.MapPath("~");
            using (StreamReader r = new StreamReader(serverPath + "app_configuration.json"))
            {
                string json = r.ReadToEnd();
                return JsonConvert.DeserializeObject<AppConfiguration>(json);
            }
        }
    }
}