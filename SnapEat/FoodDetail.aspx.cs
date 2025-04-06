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
    public partial class FoodDetail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["uID"] == null)
                {
                    btnLoginRegister.Visible = true;
                    btnAddToCart.Visible = false;
                    btnSubmit.Visible = false;
                }
                else
                {
                    btnLoginRegister.Visible = false;
                    btnAddToCart.Visible = true;
                    btnSubmit.Visible = true;
                }
                if (Session["SelectedFoodID"] != null && !string.IsNullOrEmpty(Session["SelectedFoodID"].ToString()))
                {
                    LoadFoodDetails(Session["SelectedFoodID"].ToString());
                }
                else
                {
                    Response.Redirect("Food.aspx");
                }
            }
        }

        private void LoadFoodDetails(string foodID)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                string query = "SELECT * FROM Food WHERE fID = @fID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@fID", foodID);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblFoodName.Text = reader["fName"].ToString();
                            lblFoodPrice.Text = "RM" + Convert.ToDecimal(reader["fPrice"]).ToString("0.00");
                            lblCategory.Text = reader["fCategory"].ToString();
                            lblDescription.Text = reader["fDesc"].ToString();
                            Image1.ImageUrl = reader["fImage"].ToString();
                        }
                        else
                        {
                            Response.Redirect("Food.aspx");
                        }
                    }
                }
            }
        }

        protected void btnDetails_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            DataListItem item = (DataListItem)btn.NamingContainer;

            string foodID = btn.CommandArgument;
            string foodName = ((Label)item.FindControl("fNameLabel")).Text;
            string foodPrice = ((Label)item.FindControl("fPriceLabel")).Text;

            if (!string.IsNullOrEmpty(foodID) && !string.IsNullOrEmpty(foodName))
            {
                Session["SelectedFoodID"] = foodID;
                Session["SelectedFoodName"] = foodName;
                Session["SelectedFoodPrice"] = foodPrice;
                Response.Redirect("FoodDetail.aspx");
            }
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                if (!int.TryParse(txtQuantity.Text.Trim(), out int quantity) || quantity <= 0)
                {
                    ShowAlert("Please enter a valid quantity.", "red");
                    return;
                }

                int uID = Session["uID"] != null ? Convert.ToInt32(Session["uID"]) : 0;
                int fID = Session["SelectedFoodID"] != null ? Convert.ToInt32(Session["SelectedFoodID"]) : 0;

                if (uID == 0 || fID == 0)
                {
                    ShowAlert("Invalid user or the food selection.", "red");
                    return;
                }

                string checkQuery = "SELECT COUNT(*) FROM Cart WHERE uID = @uID AND fID = @fID";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                {
                    checkCmd.Parameters.AddWithValue("@uID", uID);
                    checkCmd.Parameters.AddWithValue("@fID", fID);

                    int exists = (int)checkCmd.ExecuteScalar();

                    if (exists > 0)
                    {
                        string updateQuery = "UPDATE Cart SET quantity = quantity + @quantity WHERE uID = @uID AND fID = @fID";
                        using (SqlCommand updateCmd = new SqlCommand(updateQuery, con))
                        {
                            updateCmd.Parameters.AddWithValue("@quantity", quantity);
                            updateCmd.Parameters.AddWithValue("@uID", uID);
                            updateCmd.Parameters.AddWithValue("@fID", fID);

                            int result = updateCmd.ExecuteNonQuery();
                            if (result > 0)
                            {
                                ShowAlert("Your cart updated successfully", "green", "Cart.aspx");
                            }
                            else
                            {
                                ShowAlert("Failed to update cart.", "red");
                            }
                        }
                    }
                    else
                    {
                        string insertQuery = "INSERT INTO [Cart] ([uID], [fID], [quantity]) VALUES (@uID, @fID, @quantity)";
                        using (SqlCommand insertCmd = new SqlCommand(insertQuery, con))
                        {
                            insertCmd.Parameters.AddWithValue("@uID", uID);
                            insertCmd.Parameters.AddWithValue("@fID", fID);
                            insertCmd.Parameters.AddWithValue("@quantity", quantity);

                            int result = insertCmd.ExecuteNonQuery();
                            if (result > 0)
                            {
                                ShowAlert("You have added to cart successfully.", "green", "Cart.aspx");
                            }
                            else
                            {
                                ShowAlert("Failed to add into the cart.", "red");
                            }
                        }
                    }
                }
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlTransaction transaction = con.BeginTransaction(); // Start transaction for atomic operations

                try
                {
                    string orderQuery = "INSERT INTO [Order] ([dtCreated], [uID], [fID], [quantity], [price], [paymentStatus], [deliveryStatus]) " +
                                        "VALUES (@dtCreated, @uID, @fID, @quantity, @price, @paymentStatus, @deliveryStatus); " +
                                        "SELECT SCOPE_IDENTITY();"; // Get last inserted Order ID

                    using (SqlCommand cmd = new SqlCommand(orderQuery, con, transaction))
                    {
                        if (!int.TryParse(txtQuantity.Text.Trim(), out int quantity) || quantity <= 0)
                        {
                            ShowAlert("Please enter a valid quantity.", "red");
                            return;
                        }

                        decimal price = decimal.Parse(lblFoodPrice.Text.Replace("RM", "").Trim());
                        decimal totalPrice = price * quantity;
                        string userID = Session["uID"]?.ToString() ?? "";
                        string foodID = Session["SelectedFoodID"]?.ToString() ?? "";

                        cmd.Parameters.AddWithValue("@dtCreated", DateTime.Now);
                        cmd.Parameters.AddWithValue("@uID", userID);
                        cmd.Parameters.AddWithValue("@fID", foodID);
                        cmd.Parameters.AddWithValue("@quantity", quantity);
                        cmd.Parameters.AddWithValue("@price", totalPrice);
                        cmd.Parameters.AddWithValue("@paymentStatus", "Pending");
                        cmd.Parameters.AddWithValue("@deliveryStatus", "Processing");

                        object orderID = cmd.ExecuteScalar(); // Get the new Order ID
                        if (orderID != null)
                        {
                            // Get the food name based on fID
                            string foodName = "";
                            string foodQuery = "SELECT fName FROM Food WHERE fID = @fID";
                            using (SqlCommand foodCmd = new SqlCommand(foodQuery, con, transaction))
                            {
                                foodCmd.Parameters.AddWithValue("@fID", foodID);
                                object result = foodCmd.ExecuteScalar();
                                foodName = result?.ToString() ?? "Unknown Food";
                            }

                            // Insert Notification
                            string currentTime = DateTime.Now.ToString("dd/MM/yyyy hh:mm:sstt");
                            string notificationMsg = $"You had order {quantity} {foodName} at {currentTime}";
                            string notificationQuery = "INSERT INTO Notification (uID, notification, type) VALUES (@uID, @notification, @type)";

                            using (SqlCommand notifCmd = new SqlCommand(notificationQuery, con, transaction))
                            {
                                notifCmd.Parameters.AddWithValue("@uID", userID);
                                notifCmd.Parameters.AddWithValue("@notification", notificationMsg);
                                notifCmd.Parameters.AddWithValue("@type", notificationMsg);
                                notifCmd.ExecuteNonQuery();
                            }

                            transaction.Commit(); // Commit transaction if everything is successful
                            ShowAlert("You have submitted the order successfully.", "green", "order.aspx");
                        }
                        else
                        {
                            transaction.Rollback();
                            ShowAlert("Order submission was unsuccessful.", "red");
                        }
                    }
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    Response.Write($"Error: {ex.Message}"); // Handle the error appropriately
                }
            }
        }

        private void ShowAlert(string message, string color, string redirectUrl = "")
        {
            string script = $@"
                var overlay = document.createElement('div');
                overlay.style.position = 'fixed';
                overlay.style.top = '0';
                overlay.style.left = '0';
                overlay.style.width = '100vw';
                overlay.style.height = '100vh';
                overlay.style.background = 'rgba(0, 0, 0, 0.5)';
                overlay.style.backdropFilter = 'blur(5px)';
                overlay.style.zIndex = '999';
                document.body.appendChild(overlay);

                var alertBox = document.createElement('div');
                alertBox.innerText = '{message}';
                alertBox.style.position = 'fixed';
                alertBox.style.top = '50%';
                alertBox.style.left = '50%';
                alertBox.style.transform = 'translate(-50%, -50%)';
                alertBox.style.background = '{color}';
                alertBox.style.color = 'white';
                alertBox.style.padding = '20px';
                alertBox.style.fontSize = '20px';
                alertBox.style.textAlign = 'center';
                alertBox.style.borderRadius = '5px';
                alertBox.style.width = 'fit-content';
                alertBox.style.zIndex = '1000';

                document.body.appendChild(alertBox);

                setTimeout(function() {{
                    alertBox.remove();
                    overlay.remove();
                    {(redirectUrl != "" ? $"window.location.href = '{redirectUrl}';" : "")}
                }}, 3000);
                ";

            ScriptManager.RegisterStartupScript(this, GetType(), "autoCloseAlert", script, true);
        }
    }
}