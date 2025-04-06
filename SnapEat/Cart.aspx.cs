using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SnapEat
{
    public partial class Cart : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            object sessionUserID = Session["uID"];
            if (sessionUserID == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
            if (!IsPostBack)
            {
                CheckIfDataExists();
                CalculateGrandTotalFromSql();
            }
        }

        private void CheckIfDataExists()
        {
            if (gvCart.Rows.Count == 0)
            {
                lblNoData.Text = "No orders found.";
                lblNoData.Visible = true;
            }
            else
            {
                lblNoData.Visible = false;
            }
        }

        protected void gvCart_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCart.PageIndex = e.NewPageIndex;
            gvCart.DataBind();
            CheckIfDataExists();
        }

        private void CalculateGrandTotalFromSql()
        {
            decimal total = 0;
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
            SELECT SUM(Cart.quantity * Food.fPrice) AS TotalPrice
            FROM Cart 
            INNER JOIN Food ON Cart.fID = Food.fID
            WHERE Cart.uID = @uID
            GROUP BY Cart.fID;";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@uID", Session["uID"]);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            total += reader.GetDecimal(0);
                        }
                    }
                }
            }

            lblGrandTotal.Text = total.ToString("0.00");
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            int userID = Convert.ToInt32(Session["uID"]);
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string selectQuery = @"
            SELECT Cart.fID, SUM(Cart.quantity) AS TotalQuantity, Food.fPrice 
            FROM Cart 
            INNER JOIN Food ON Cart.fID = Food.fID 
            WHERE Cart.uID = @uID 
            GROUP BY Cart.fID, Food.fPrice;";  // 🔥 Ensures items are grouped

                List<Tuple<int, int, decimal>> cartItems = new List<Tuple<int, int, decimal>>();

                using (SqlCommand selectCmd = new SqlCommand(selectQuery, conn))
                {
                    selectCmd.Parameters.AddWithValue("@uID", userID);
                    using (SqlDataReader reader = selectCmd.ExecuteReader())
                    {
                        if (!reader.HasRows)
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "alert",
                                "alert('Your cart is empty. Add items before checking out');", true);
                            return;
                        }

                        while (reader.Read())
                        {
                            cartItems.Add(new Tuple<int, int, decimal>(
                                Convert.ToInt32(reader["fID"]),
                                Convert.ToInt32(reader["TotalQuantity"]),  // 🔥 Uses summed quantity
                                Convert.ToDecimal(reader["fPrice"])
                            ));
                        }
                    }
                }

                string insertQuery = @"
            INSERT INTO [Order] ([dtCreated], [uID], [fID], [quantity], [price], [paymentStatus], [deliveryStatus]) 
            VALUES (@dtCreated, @uID, @fID, @quantity, @price, @paymentStatus, @deliveryStatus)";

                using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                {
                    insertCmd.Parameters.AddWithValue("@dtCreated", DateTime.Now);
                    insertCmd.Parameters.AddWithValue("@uID", userID);
                    insertCmd.Parameters.AddWithValue("@paymentStatus", "Pending");
                    insertCmd.Parameters.AddWithValue("@deliveryStatus", "Pending");

                    foreach (var item in cartItems)
                    {
                        insertCmd.Parameters.AddWithValue("@fID", item.Item1);
                        insertCmd.Parameters.AddWithValue("@quantity", item.Item2);
                        insertCmd.Parameters.AddWithValue("@price", item.Item3);

                        insertCmd.ExecuteNonQuery();

                        insertCmd.Parameters.Clear();
                        insertCmd.Parameters.AddWithValue("@dtCreated", DateTime.Now);
                        insertCmd.Parameters.AddWithValue("@uID", userID);
                        insertCmd.Parameters.AddWithValue("@paymentStatus", "Pending");
                        insertCmd.Parameters.AddWithValue("@deliveryStatus", "Pending");
                    }
                }

                string deleteQuery = "DELETE FROM Cart WHERE uID = @uID";
                using (SqlCommand deleteCmd = new SqlCommand(deleteQuery, conn))
                {
                    deleteCmd.Parameters.AddWithValue("@uID", userID);
                    deleteCmd.ExecuteNonQuery();
                }
            }

            ClientScript.RegisterStartupScript(this.GetType(), "alert",
                "alert('Checkout successful! Your order has been placed.'); window.location.href='Order.aspx';", true);
        }

        protected void GvCart_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                string query = "";

                if (e.CommandName == "Increase")
                {
                    query = "UPDATE Cart SET quantity = quantity + 1 WHERE cID = @cID";
                }
                else if (e.CommandName == "Decrease")
                {
                    query = "UPDATE Cart SET quantity = CASE WHEN quantity > 1 THEN quantity - 1 ELSE 1 END WHERE cID = @cID";
                }
                else if (e.CommandName == "Remove")
                {
                    query = "DELETE FROM Cart WHERE cID = @cID";
                }

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@cID", e.CommandArgument);
                    cmd.ExecuteNonQuery();
                }

                gvCart.DataBind();
                CalculateGrandTotalFromSql();
            }
        }
    }
}