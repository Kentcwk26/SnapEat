using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SnapEat
{
    public partial class ManageOrders : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["uID"] == null || Session["uRole"] == null || (Session["uRole"].ToString() != "Admin" && Session["uRole"].ToString() != "Staff"))
            {
                Response.Redirect("Login.aspx");
            }
            if (!IsPostBack)
            {
                DropDownList1.SelectedValue = "Pending";
                BindData();
            }
        }

        protected void gvCart_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int rowIndex = Convert.ToInt32(((GridViewRow)((Control)e.CommandSource).NamingContainer).RowIndex);
            GridViewRow row = gvCart.Rows[rowIndex];
            string oID = e.CommandArgument.ToString();

            // Shared controls
            Button btnToggle = (Button)row.FindControl("btnEditUpdate");
            Button btnCancel = (Button)row.FindControl("btnCancel");

            Label lblPayment = (Label)row.FindControl("lblPaymentStatus");
            Label lblDelivery = (Label)row.FindControl("lblDeliveryStatus");

            DropDownList ddlPayment = (DropDownList)row.FindControl("ddlPaymentStatus");
            DropDownList ddlDelivery = (DropDownList)row.FindControl("ddlDeliveryStatus");

            if (e.CommandName == "ToggleEdit")
            {
                if (btnToggle.Text == "Edit")
                {
                    // Switch to edit mode
                    ddlPayment.SelectedValue = lblPayment.Text;
                    ddlDelivery.SelectedValue = lblDelivery.Text;

                    lblPayment.Visible = false;
                    lblDelivery.Visible = false;
                    ddlPayment.Visible = true;
                    ddlDelivery.Visible = true;

                    btnToggle.Text = "Update";
                    btnCancel.Visible = true;
                }
                else if (btnToggle.Text == "Update")
                {
                    // Update database
                    string newPaymentStatus = ddlPayment.SelectedValue;
                    string newDeliveryStatus = ddlDelivery.SelectedValue;

                    string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string query = "UPDATE [Order] SET paymentStatus = @paymentStatus, deliveryStatus = @deliveryStatus WHERE oID = @oID";
                        SqlCommand cmd = new SqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@paymentStatus", newPaymentStatus);
                        cmd.Parameters.AddWithValue("@deliveryStatus", newDeliveryStatus);
                        cmd.Parameters.AddWithValue("@oID", oID);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                    }

                    // Update display
                    lblPayment.Text = newPaymentStatus;
                    lblDelivery.Text = newDeliveryStatus;

                    lblPayment.Visible = true;
                    lblDelivery.Visible = true;
                    ddlPayment.Visible = false;
                    ddlDelivery.Visible = false;

                    btnToggle.Text = "Edit";
                    btnCancel.Visible = false;
                }
            }
            else if (e.CommandName == "CancelEdit")
            {
                // Revert UI to non-edit state without saving
                lblPayment.Visible = true;
                lblDelivery.Visible = true;
                ddlPayment.Visible = false;
                ddlDelivery.Visible = false;

                btnToggle.Text = "Edit";
                btnCancel.Visible = false;
            }
        }

        protected void gvCart_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string paymentStatus = DataBinder.Eval(e.Row.DataItem, "paymentStatus")?.ToString();
                string deliveryStatus = DataBinder.Eval(e.Row.DataItem, "deliveryStatus")?.ToString();

                // Find the Edit and Cancel buttons
                Button btnEdit = (Button)e.Row.FindControl("btnEditUpdate");
                Button btnCancel = (Button)e.Row.FindControl("btnCancel");

                // If order is fully completed (both payment and delivery), hide or disable buttons
                if (paymentStatus == "Completed" && deliveryStatus == "Completed")
                {
                    if (btnEdit != null)
                    {
                        btnEdit.Enabled = false;
                        btnEdit.CssClass = "btn btn-grey";
                        btnEdit.Enabled = false;
                    }

                    if (btnCancel != null)
                    {
                        btnCancel.Visible = false;
                    }
                }
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            BindData();
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            DropDownList1.SelectedIndex = 1;
        }

        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindData();
        }

        private void BindData()
        {
            string selectedCategory = DropDownList1.SelectedValue;
            string searchText = txtSearch.Text.Trim();

            string baseQuery = @"SELECT o.oID, o.dtCreated, f.fName, o.quantity, o.price, o.paymentStatus, o.deliveryStatus, O.formatted_oID FROM [Order] o JOIN [Food] f ON o.fID = f.fID";

            switch (selectedCategory)
            {
                default:
                    baseQuery += " ORDER BY o.formatted_oID DESC";
                    break;
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
                case "Pending":
                    baseQuery += " AND (o.paymentStatus = 'Pending' OR o.deliveryStatus = 'Pending')";
                    break;
                case "Completed":
                    baseQuery += " AND (o.paymentStatus = 'Completed' AND o.deliveryStatus = 'Completed')";
                    break;
            }

            if (!string.IsNullOrEmpty(searchText))
            {
                baseQuery += " AND f.fName LIKE @Search";
            }

            SqlDataSource1.SelectCommand = baseQuery;
            SqlDataSource1.SelectParameters.Clear();

            if (!string.IsNullOrEmpty(searchText))
            {
                SqlDataSource1.SelectParameters.Add("Search", "%" + searchText + "%");
            }

            SqlDataSource1.DataBind();
        }
    }
}
