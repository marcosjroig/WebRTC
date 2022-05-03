using System;
using System.IO;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebRtc.BusinessLogic;

namespace WebRtc.Pages
{
    public partial class Camara : System.Web.UI.Page
    {
        private static string k;
        private static string c;
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!Page.IsPostBack)
            {
                if (Request.QueryString.Count == 0)
                {
                    Response.Redirect("~/Default.aspx");
                }

                if (string.IsNullOrEmpty(Request.Params["k"]) || string.IsNullOrEmpty(Request.Params["c"]) || string.IsNullOrEmpty(Request.Params["t"]))
                {
                    Response.Redirect("~/Default.aspx");
                }

                k = Request.Params["k"];
                c = Request.Params["c"];

                var abilitareScattaFoto = AbilitaVideoPerizia();
                attivaScattaFoto.Value = (abilitareScattaFoto == 0).ToString();
                var configuration = AppConfigurationReader.ReadJson();

                if (abilitareScattaFoto == 0)
                {
                    lblError.Visible = false;
                    lblOk.Visible = true;
                    lblOk.Text = configuration.msgOKAbilia;
                }
                else
                {
                    lblOk.Visible = false;
                    lblError.Visible = true;
                    lblError.Text = configuration.msgOKAbilia; ;
                }

                //Label configurafili da file config
                lblDescrizione.Text = configuration.lblDescrizione;
                imgLogo.Src = configuration.urlLogo;
                lblTipoCamera.Text = configuration.lblTipoCamera;
                lblRisoluzione.Text = configuration.lblRisoluzione;
            }
        }

        protected void btnAggiorna_OnClick(object sender, EventArgs e)
        {
            Page.Response.Redirect(Page.Request.Url.ToString(), true);
        }

        protected void btnTermina_OnClick(object sender, EventArgs e)
        {
            var risultatoOperazione = new ClVideoPerizia().SalvaVideoPerizia();
            var configuration = AppConfigurationReader.ReadJson();

            
        }

        [WebMethod]
        public static void btnTerminaOnClick(string video, string videoName)
        {
            try
            {
                var configuration = AppConfigurationReader.ReadJson();
                var directoryPath = configuration.MediaFileBasePath + @"\" + k + @"\" + c + @"\";
                var fileNameWitPath = directoryPath + videoName;
                var converted = video.Replace(@"data:video/webm;base64,", "");

                CreateDirectory(directoryPath);

                using (FileStream fs = new FileStream(fileNameWitPath, FileMode.Create))
                {
                    using (BinaryWriter bw = new BinaryWriter(fs))
                    {
                        byte[] data = Convert.FromBase64String(converted);
                        bw.Write(data, 0, data.Length);
                        bw.Close();
                    }
                }

                var risultatoOperazione = new ClVideoPerizia().SalvaVideoPerizia();
                SetMesaggioSalvataggio(risultatoOperazione);
            }
            catch (Exception e)
            {
                SetMesaggioErroreSalvataggio();
            }
        }

        [WebMethod]
        public static void btnTerminaOnClick2(string foto, string fotoName)
        {
            try
            {
                var configuration = AppConfigurationReader.ReadJson();
                var directoryPath = configuration.MediaFileBasePath + @"\" + k + @"\" + c + @"\";
                var fileNameWitPath = directoryPath + fotoName;
                var converted = foto.Replace(@"data:video/webm;base64,", "");

                CreateDirectory(directoryPath);

                using (FileStream fs = new FileStream(fileNameWitPath, FileMode.Create))
                {
                    using (BinaryWriter bw = new BinaryWriter(fs))
                    {
                        byte[] data = Convert.FromBase64String(converted);
                        bw.Write(data, 0, data.Length);
                        bw.Close();
                    }
                }

                var risultatoOperazione = new ClVideoPerizia().SalvaVideoPerizia();
                SetMesaggioSalvataggio(risultatoOperazione);
            }
            catch (Exception e)
            {
                SetMesaggioErroreSalvataggio();
            }
            
        }

        private static void SetMesaggioSalvataggio(byte risultatoOperazione)
        {
            var configuration = AppConfigurationReader.ReadJson();
            //Page page = (Page)HttpContext.Current.Handler;
            //Label lblOk = (Label)page.FindControl("lblOk");
            //Label lblError = (Label)page.FindControl("lblError");

            //if (risultatoOperazione == 0)
            //{
            //    lblError.Visible = false;
            //    lblOk.Visible = true;
            //    lblOk.Text = configuration.msgOKSalva;
            //}
            //else
            //{
            //    lblOk.Visible = false;
            //    lblError.Visible = true;
            //    lblError.Text = configuration.msgKOSalva; ;
            //}
        }

        private static void SetMesaggioErroreSalvataggio()
        {
            var configuration = AppConfigurationReader.ReadJson();
            //Page page = (Page)HttpContext.Current.Handler;
            //Label lblOk = (Label)page.FindControl("lblOk");
            //Label lblError = (Label)page.FindControl("lblError");
            //lblOk.Visible = false;
            //lblError.Visible = true;
            //lblError.Text = configuration.msgKOSalva; 
        }
        private static void CreateDirectory(string path)
        {
            bool exists = System.IO.Directory.Exists(path);

            if (!exists)
            {
                Directory.CreateDirectory(path);
            }
        }

        private byte AbilitaVideoPerizia()
        {
            //TODO: cambiare il codice con quello che fa il calcolo di questo valore
            byte zero = 0;
            return zero;
        }
    }
}