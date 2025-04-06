using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SnapEat
{
    public partial class ViewFeedbacks : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["uID"] == null || Session["uRole"] == null || Session["uRole"].ToString() != "Admin")
            {
                Response.Redirect("Login.aspx");
            }
        }
    }
}