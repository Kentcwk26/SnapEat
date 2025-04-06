using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SnapEat
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["uID"] != null)
            {
                Label1.Text = "Welcome to SnapEat website, " + Session["uName"].ToString() + " !";
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
            }
            if (!IsPostBack)
            {
                BindData();
            }
        }

        protected void ButtonLogOut_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Default.aspx");
        }

        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindData();
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            BindData();
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            DropDownList1.SelectedIndex = 0;
            BindData();
        }

        protected void btnDetails_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            DataListItem item = (DataListItem)btn.NamingContainer;

            string foodID = btn.CommandArgument;
            string foodName = ((Label)item.FindControl("fNameLabel")).Text;

            if (!string.IsNullOrEmpty(foodID) && !string.IsNullOrEmpty(foodName))
            {
                Session["SelectedFoodID"] = foodID;
                Session["SelectedFoodName"] = foodName;
                Response.Redirect("FoodDetail.aspx");
            }
        }

        private void BindData()
        {
            string selectedCategory = DropDownList1.SelectedValue;
            string searchText = txtSearch.Text.Trim();

            string query = "SELECT * FROM Food WHERE 1=1";

            if (selectedCategory != "Default")
            {
                query += " AND fCategory = @Category";
            }

            if (!string.IsNullOrEmpty(searchText))
            {
                query += " AND fName LIKE @Search";
            }

            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (selectedCategory != "Default")
                    {
                        cmd.Parameters.AddWithValue("@Category", selectedCategory);
                    }

                    if (!string.IsNullOrEmpty(searchText))
                    {
                        cmd.Parameters.AddWithValue("@Search", "%" + searchText + "%");
                    }

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    DataList1.DataSourceID = null;
                    DataList1.DataSource = reader;
                    DataList1.DataBind();
                }
            }
        }
    }
}