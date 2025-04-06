using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SnapEat
{
    public partial class Admin_Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["uID"] != null && (Session["uRole"].ToString() == "Admin"))
            {
                Label1.Text = "Welcome back, " + Session["uName"].ToString() + " !";
                btnLogOut.Visible = true;
                lnkMP.Visible = true;
                lnkLoginlnkRegister.Visible = false;
            }
            else
            {
                Label1.Text = "Welcome to SnapEat Website";
                btnLogOut.Visible = false;
                lnkMP.Visible = false;
                lnkLoginlnkRegister.Visible = true;
                Response.Redirect("Login.aspx");
            }
        }

        protected void ButtonLogOut_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Default.aspx");
        }
    }
}