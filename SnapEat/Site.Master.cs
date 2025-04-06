using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;

namespace SnapEat
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["uID"] != null)
                {
                    btnLoginRegister.Text = "Manage Profile";
                    btnLoginRegister.PostBackUrl = "~/ManageUProfile.aspx";

                    LoadNotificationCount(Session["uID"].ToString());
                }
                else
                {
                    btnLoginRegister.Text = "Login / Register";
                    btnLoginRegister.PostBackUrl = "~/Login.aspx";

                    lnkNotifications.Text = "Notifications";
                }
            }
        }

        protected void lnkHome_Click(object sender, EventArgs e)
        {
            string homeUrl = Session["HomeUrl"] != null ? Session["HomeUrl"].ToString() : "~/default.aspx";
            Response.Redirect(homeUrl);
        }

        private void LoadNotificationCount(string userId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                string query = "SELECT COUNT(*) FROM Notification WHERE uID = @uID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@uID", userId);
                    int count = (int)cmd.ExecuteScalar();

                    if (count > 0)
                    {
                        lnkNotifications.Text = "Notifications"; // Keep the text clean
                        notificationBadge.InnerText = count.ToString(); // Set the badge number
                        notificationBadge.Style["display"] = "inline-block"; // Show the badge
                    }
                    else
                    {
                        notificationBadge.Style["display"] = "none"; // Hide the badge if 0 notifications
                    }
                }
            }
        }

    }
}
