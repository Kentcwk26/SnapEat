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
    public partial class ManageFProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["uID"] == null || Session["uRole"] == null || (Session["uRole"].ToString() != "Admin" && Session["uRole"].ToString() != "Staff"))
            {
                Response.Redirect("Login.aspx");
            }
            if (!Page.IsPostBack)
            {
                LoadFoodDetails();
                Image1.ImageUrl = "~/FoodImages/default.png";
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                string query = @"INSERT INTO Food (fName, fDesc, fImage, fCategory, fPrice, dtCreated) 
                                 VALUES (@fName, @fDesc, @fImage, @fCategory, @fPrice, @dtCreated)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@fName", fName.Text);
                    if (string.IsNullOrWhiteSpace(fName.Text))
                    {
                        ShowErrorAlert("Registration unsuccessful, please enter food name");
                        return;
                    }

                    cmd.Parameters.AddWithValue("@fDesc", fDesc.Text);
                    if (string.IsNullOrWhiteSpace(fDesc.Text))
                    {
                        ShowErrorAlert("Registration unsuccessful, please enter food description");
                        return;
                    }

                    string imagePath = "";
                    if (fImage.HasFile)
                    {
                        imagePath = "~/FoodImages/" + fImage.FileName;
                        fImage.SaveAs(Server.MapPath(imagePath));
                    }
                    else
                    {
                        ShowErrorAlert("Registration unsuccessful, please include food image");
                        return;
                    }
                    cmd.Parameters.AddWithValue("@fImage", imagePath);

                    if (fCategory.SelectedItem == null)
                    {
                        ShowErrorAlert("Registration unsuccessful, please select food category");
                        return;
                    }
                    cmd.Parameters.AddWithValue("@fCategory", fCategory.SelectedValue);

                    if (string.IsNullOrWhiteSpace(fPrice.Text) || !decimal.TryParse(fPrice.Text, out decimal price) || price <= 0)
                    {
                        ShowErrorAlert("Registration unsuccessful, please enter a valid food price");
                        return;
                    }
                    cmd.Parameters.AddWithValue("@fPrice", price);

                    void ShowErrorAlert(string message)
                    {
                        string errorScript = $@"
                            var alertBox = document.createElement('div');
                            alertBox.innerText = '{message}';
                            alertBox.style.position = 'fixed';
                            alertBox.style.top = '50%';
                            alertBox.style.left = '50%';
                            alertBox.style.transform = 'translate(-50%, -50%)';
                            alertBox.style.background = 'red';
                            alertBox.style.color = 'white';
                            alertBox.style.padding = '20px';
                            alertBox.style.fontSize = '20px';
                            alertBox.style.textAlign = 'center';
                            alertBox.style.borderRadius = '5px';
                            alertBox.style.width = 'fit-content';
                            alertBox.style.zIndex = '1000';
                            document.body.appendChild(alertBox);
        
                            setTimeout(function() {{ alertBox.remove(); }}, 3000);
                        ";
                        ClientScript.RegisterStartupScript(this.GetType(), "errorAlert", errorScript, true);
                    }

                    cmd.Parameters.AddWithValue("@dtCreated", DateTime.Now);

                    cmd.ExecuteNonQuery();
                }
            }

            lblMessage.Text = "Food Profile has been added successfully!";
            ClearFields();
        }

        private void ClearFields()
        {
            fName.Text = "";
            fDesc.Text = "";
            fPrice.Text = "";
            fCategory.ClearSelection();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "clearFile", "document.getElementById('" + fImage.ClientID + "').value = '';", true);

            Image1.ImageUrl = "~/FoodImages/no-image.png";

            Session["FID"] = null;

            btnAdd.Enabled = true;
            btnEdit.Visible = false;
            btnDelete.Visible = false;
        }

        private void LoadFoodDetails()
        {
            if (Session["FID"] == null)
            {
                lblMessage.Text = "No Food ID selected!";
                btnEdit.Visible = false;
                btnDelete.Visible = false;
                return;
            }

            string fid = Session["FID"].ToString();
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                string query = "SELECT fName, fDesc, fImage, fCategory, fPrice FROM Food WHERE FID = @FID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@FID", fid);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            fID.Text = fid;
                            fName.Text = reader["fName"].ToString();
                            fDesc.Text = reader["fDesc"].ToString();
                            fPrice.Text = reader["fPrice"].ToString();

                            string category = reader["fCategory"].ToString();
                            ListItem item = fCategory.Items.FindByValue(category);
                            if (item != null)
                            {
                                fCategory.ClearSelection();
                                item.Selected = true;
                            }

                            if (!string.IsNullOrEmpty(reader["fImage"].ToString()))
                            {
                                string imagePath = reader["fImage"].ToString();
                                if (!imagePath.StartsWith("~"))
                                {
                                    imagePath = "~/" + imagePath.TrimStart('/');
                                }

                                Image1.ImageUrl = ResolveUrl(imagePath);
                            }
                            else
                            {
                                Image1.ImageUrl = "~/FoodImages/no-image.png";
                            }

                            btnAdd.Visible = false;
                            btnEdit.Visible = true;
                            btnDelete.Visible = true;
                        }
                        else
                        {
                            lblMessage.Text = "No record found!";
                        }
                    }
                }
            }
        }

        private void UpdateFood()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                string existingImagePath = "";
                string selectQuery = "SELECT fImage FROM Food WHERE FID = @FID";

                using (SqlCommand selectCmd = new SqlCommand(selectQuery, con))
                {
                    selectCmd.Parameters.AddWithValue("@FID", Session["FID"]);
                    object result = selectCmd.ExecuteScalar();
                    if (result != null)
                    {
                        existingImagePath = result.ToString();
                    }
                }

                string imagePath = existingImagePath;
                if (fImage.HasFile)
                {
                    imagePath = "~/FoodImages/" + fImage.FileName;
                    fImage.SaveAs(Server.MapPath(imagePath));
                }

                string updateQuery = @"UPDATE Food 
                               SET fName = @fName, fDesc = @fDesc, fImage = @fImage, 
                                   fCategory = @fCategory, fPrice = @fPrice
                               WHERE FID = @FID";

                using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                {
                    cmd.Parameters.AddWithValue("@fName", fName.Text);
                    cmd.Parameters.AddWithValue("@fDesc", fDesc.Text);
                    cmd.Parameters.AddWithValue("@fImage", imagePath);
                    cmd.Parameters.AddWithValue("@fCategory", fCategory.SelectedValue);
                    cmd.Parameters.AddWithValue("@fPrice", Convert.ToDecimal(fPrice.Text));
                    cmd.Parameters.AddWithValue("@FID", Session["FID"]);

                    cmd.ExecuteNonQuery();
                }
            }

            lblMessage.Text = "Food Updated!";
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            UpdateFood();
            lblMessage.Text = "Food Updated!";
            Response.AddHeader("REFRESH", "2;ManageFProfile.aspx");
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                string query = "DELETE FROM Food WHERE FID = @FID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@FID", Session["FID"]);
                    cmd.ExecuteNonQuery();
                }
            }

            lblMessage.Text = "Food has been deleted successfully!";
            Response.AddHeader("REFRESH", "2;ManageFProfile.aspx");
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            Session["FID"] = GridView1.SelectedDataKey.Value.ToString();
            LoadFoodDetails();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearFields();
        }
    }
}