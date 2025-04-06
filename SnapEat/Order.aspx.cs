using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SnapEat
{
    public partial class Order : System.Web.UI.Page
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
                BindData();
            }
        }

        private void CheckIfDataExists()
        {
            if (GridView1.Rows.Count == 0)
            {
                lblNoData.Text = "No orders found.";
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
        }
        private void BindData()
        {
            string selectedCategory = DropDownList1.SelectedValue;
            string searchText = txtSearch.Text.Trim();

            string baseQuery = @"SELECT o.oID, o.dtCreated, f.fName AS FoodName, o.quantity, o.price, o.paymentStatus, o.deliveryStatus FROM [Order] o JOIN [Food] f ON o.fID = f.fID WHERE o.uID = @uID";

            switch (selectedCategory)
            {
                case "Latest":
                    baseQuery += " ORDER BY o.dtCreated DESC";
                    break;
                case "Earliest":
                    baseQuery += " ORDER BY o.dtCreated ASC";
                    break;
                case "PaymentCompleted":
                    baseQuery += " AND o.paymentStatus = 'Completed'";
                    break;
                case "PendingPayment":
                    baseQuery += " AND o.paymentStatus = 'Pending'";
                    break;
                case "DeliveryCompleted":
                    baseQuery += " AND o.deliveryStatus = 'Completed'";
                    break;
                case "PendingDelivery":
                    baseQuery += " AND o.deliveryStatus = 'Pending'";
                    break;
            }

            if (!string.IsNullOrEmpty(searchText))
            {
                baseQuery += " AND f.fName LIKE @Search";
            }

            SqlDataSource1.SelectCommand = baseQuery;
            SqlDataSource1.SelectParameters.Clear();

            SqlDataSource1.SelectParameters.Add("uID", Session["uID"].ToString());

            if (!string.IsNullOrEmpty(searchText))
            {
                SqlDataSource1.SelectParameters.Add("Search", "%" + searchText + "%");
            }

            SqlDataSource1.DataBind();
        }
    }
}