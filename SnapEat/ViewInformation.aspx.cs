using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SnapEat
{
    public partial class ViewInformation : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["uID"] == null || Session["uRole"] == null || Session["uRole"].ToString() != "Admin")
            {
                Response.Redirect("Login.aspx");
            }
            if (!IsPostBack)
            {
                ApplyFilter();
            }
        }

        private void ApplyFilter()
        {
            // Clear previous parameters to avoid duplicate declarations
            SqlDataSource1.SelectParameters.Clear();

            string query = "SELECT * FROM [User] WHERE 1=1";

            if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
            {
                query += " AND (uName LIKE '%' + @searchQuery + '%' OR uEmail LIKE '%' + @searchQuery + '%' OR formatted_uID LIKE '%' + @searchQuery + '%')";
                SqlDataSource1.SelectParameters.Add("searchQuery", txtSearch.Text.Trim());
            }

            if (DropDownList1.SelectedValue != "Default")
            {
                query += " AND uRole = @roleFilter";
                SqlDataSource1.SelectParameters.Add("roleFilter", DropDownList1.SelectedValue);
            }

            SqlDataSource1.SelectCommand = query;
            DataList1.DataBind(); // Refresh UI
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            ApplyFilter();
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            DropDownList1.SelectedValue = "Default";
            ApplyFilter();
        }

        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            ApplyFilter();
        }
    }
}
