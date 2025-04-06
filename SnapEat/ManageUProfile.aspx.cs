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
    public partial class ManageUProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Session["uID"] == null)
                {
                    Response.Redirect("Login.aspx");
                }
                else
                {
                    LoadUserDetails();
                }
            }
        }

        private void LoadUserDetails()
        {
            if (Session["uID"] == null)
            {
                lblMessage.Text = "No User ID selected!";
                return;
            }

            int uID = Convert.ToInt32(Session["uID"]);
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                string query = "SELECT uName, uEmail, uContact, uGender, uPassword, uBirthday, uProfile FROM [User] WHERE uID = @uID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@uID", uID);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            uName.Text = reader["uName"].ToString();
                            uContact.Text = reader["uContact"].ToString();
                            uEmail.Text = reader["uEmail"].ToString();
                            uPassword.Text = reader["uPassword"].ToString();
                            uBirthday.Text = reader["uBirthday"] != DBNull.Value ? Convert.ToDateTime(reader["uBirthday"]).ToString("yyyy-MM-dd") : "";

                            string gender = reader["uGender"].ToString();
                            ListItem item = uGender.Items.FindByValue(gender);
                            if (item != null)
                            {
                                uGender.ClearSelection();
                                item.Selected = true;
                            }

                            string imagePath = reader["uProfile"].ToString();
                            if (!string.IsNullOrEmpty(imagePath))
                            {
                                if (!imagePath.StartsWith("~"))
                                {
                                    imagePath = "~/" + imagePath.TrimStart('/');
                                }
                                Image1.ImageUrl = ResolveUrl(imagePath);
                            }
                            else
                            {
                                Image1.ImageUrl = "~/UserProfiles/no-image.png";
                            }
                        }
                        else
                        {
                            lblMessage.Text = "No records were found!";
                        }
                    }
                }
            }
        }

        private void ClearFields()
        {
            uName.Text = "";
            uContact.Text = "";
            uEmail.Text = "";
            uPassword.Text = "";
            uBirthday.Text = "";

            uGender.ClearSelection();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "clearFile", "document.getElementById('" + uProfile.ClientID + "').value = '';", true);

            Image1.ImageUrl = "~/UserProfiles/no-image.png";
            Session["uID"] = null;
        }

        private void UpdateUser()
        {
            if (Session["uID"] == null)
            {
                lblMessage.Text = "User ID is missing!";
                return;
            }

            int uID = Convert.ToInt32(Session["uID"]);
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                string query = @"UPDATE [User] SET 
                                [dtCreated] = @dtCreated, 
                                [uName] = @uName, 
                                [uGender] = @uGender, 
                                [uProfile] = @uProfile, 
                                [uEmail] = @uEmail, 
                                [uPassword] = @uPassword, 
                                [uContact] = @uContact, 
                                [uBirthday] = @uBirthday, 
                                [uRole] = @uRole 
                                WHERE [uID] = @uID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@uName", uName.Text);
                    cmd.Parameters.AddWithValue("@uEmail", uEmail.Text);
                    cmd.Parameters.AddWithValue("@uContact", uContact.Text);
                    cmd.Parameters.AddWithValue("@uPassword", uPassword.Text);
                    cmd.Parameters.AddWithValue("@uBirthday", uBirthday.Text);

                    string imagePath = Image1.ImageUrl;
                    if (uProfile.HasFile)
                    {
                        imagePath = "~/UserProfiles/" + uProfile.FileName;
                        uProfile.SaveAs(Server.MapPath(imagePath));
                    }

                    cmd.Parameters.AddWithValue("@uProfile", imagePath);
                    cmd.Parameters.AddWithValue("@uGender", uGender.SelectedValue);
                    cmd.Parameters.AddWithValue("@dtCreated", DateTime.Now);
                    cmd.Parameters.AddWithValue("@uRole", "User");
                    cmd.Parameters.AddWithValue("@uID", uID);

                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void BtnUpdate_Click(object sender, EventArgs e)
        {
            UpdateUser();

            try
            {
                string script = @"
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
                    alertBox.innerText = 'Edit User Profile Successfully';
                    alertBox.style.position = 'fixed';
                    alertBox.style.top = '50%';
                    alertBox.style.left = '50%';
                    alertBox.style.transform = 'translate(-50%, -50%)';
                    alertBox.style.background = 'green';
                    alertBox.style.color = 'white';
                    alertBox.style.padding = '20px';
                    alertBox.style.fontSize = '20px';
                    alertBox.style.textAlign = 'center';
                    alertBox.style.borderRadius = '5px';
                    alertBox.style.width = '300px';
                    alertBox.style.zIndex = '1000';
                    document.body.appendChild(alertBox);
                
                    setTimeout(function() { 
                        alertBox.remove(); 
                        overlay.remove(); 
                    }, 3000);
                ";
                ClientScript.RegisterStartupScript(this.GetType(), "autoCloseAlert", script, true);

                ClearFields();
            }
            catch (Exception ex)
            {
                string errorScript = @"
                    var alertBox = document.createElement('div');
                    alertBox.innerText = 'Edit User Profile Unsuccessful! Please try again later';
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
                
                    setTimeout(function() { alertBox.remove(); }, 3000);
                ";
                ClientScript.RegisterStartupScript(this.GetType(), "errorAlert", errorScript, true);

                lblMessage.Text = "Error: " + ex.Message;
            }

            Response.AddHeader("REFRESH", "2;ManageUProfile.aspx");
        }

        protected void BtnDelete_Click(object sender, EventArgs e)
        {
            if (Session["uID"] == null)
            {
                lblMessage.Text = "User ID is missing!";
                return;
            }

            int uID = Convert.ToInt32(Session["uID"]);
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                string query = "DELETE FROM User WHERE uID = @uID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@uID", uID);
                    cmd.ExecuteNonQuery();
                }
            }

            try
            {
                string script = @"
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
                    alertBox.innerText = 'Delete User Profile Successfully';
                    alertBox.style.position = 'fixed';
                    alertBox.style.top = '50%';
                    alertBox.style.left = '50%';
                    alertBox.style.transform = 'translate(-50%, -50%)';
                    alertBox.style.background = 'green';
                    alertBox.style.color = 'white';
                    alertBox.style.padding = '20px';
                    alertBox.style.fontSize = '20px';
                    alertBox.style.textAlign = 'center';
                    alertBox.style.borderRadius = '5px';
                    alertBox.style.width = '300px';
                    alertBox.style.zIndex = '1000';
                    document.body.appendChild(alertBox);
                
                    setTimeout(function() { 
                        alertBox.remove(); 
                        overlay.remove(); 
                    }, 3000);
                ";
                ClientScript.RegisterStartupScript(this.GetType(), "autoCloseAlert", script, true);

                ClearFields();
            }
            catch (Exception ex)
            {
                string errorScript = @"
                    var alertBox = document.createElement('div');
                    alertBox.innerText = 'Delete User Profile Unsuccessful! Please try again later';
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
                
                    setTimeout(function() { alertBox.remove(); }, 3000);
                ";
                ClientScript.RegisterStartupScript(this.GetType(), "errorAlert", errorScript, true);

                lblMessage.Text = "Error: " + ex.Message;
            }

            Response.AddHeader("REFRESH", "2;Login.aspx");
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx");
            ClearFields();
        }
        protected void Button1_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Default.aspx");
        }
    }
}