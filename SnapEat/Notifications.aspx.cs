using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SnapEat
{
    public partial class Notifications : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["uID"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            if (!IsPostBack)
            {
                CheckIfDataExists();
            }
        }

        private void CheckIfDataExists()
        {
            if (GridView1.Rows.Count == 0)
            {
                lblNoData.Text = "No notifications found.";
                lblNoData.Visible = true;
            }
            else
            {
                lblNoData.Visible = false;
            }
        }

        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView1.PageIndex = e.NewPageIndex;
            GridView1.DataBind();
            CheckIfDataExists();
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteNotification")
            {
                int nID = Convert.ToInt32(e.CommandArgument);
                SqlDataSource1.DeleteParameters["nID"].DefaultValue = nID.ToString();
                SqlDataSource1.Delete();
                GridView1.DataBind();
                CheckIfDataExists();
            }
        }
    }
}