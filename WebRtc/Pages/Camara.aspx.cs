using System;
using System.Web.UI;

namespace WebRtc.Pages
{
    public partial class Camara : System.Web.UI.Page
    {
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
            }
        }

        protected void btnAggiorna_OnClick(object sender, EventArgs e)
        {
            Page.Response.Redirect(Page.Request.Url.ToString(), true);
        }

        protected void btnTermina_OnClick(object sender, EventArgs e)
        {
            throw new NotImplementedException();
        }

        private bool VideoPerizia()
        {
            return true;
        }
    }
}