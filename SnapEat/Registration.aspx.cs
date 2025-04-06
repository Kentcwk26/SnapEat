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
    public partial class Registration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                string query = @"INSERT INTO [User] ([dtCreated], [uName], [uGender], [uProfile], [uEmail], [uPassword], [uContact], [uBirthday], [uRole]) VALUES (@dtCreated, @uName, @uGender, @uProfile, @uEmail, @uPassword, @uContact, @uBirthday, @uRole)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@uName", uName.Text);
                    cmd.Parameters.AddWithValue("@uEmail", uEmail.Text);
                    cmd.Parameters.AddWithValue("@uContact", uContact.Text);
                    cmd.Parameters.AddWithValue("@uPassword", uPassword.Text);
                    cmd.Parameters.AddWithValue("@uBirthday", uBirthday.Text);

                    string imagePath = "~/UserProfiles/default.png";
                    if (uProfile.HasFile)
                    {
                        imagePath = "~/UserProfiles/" + uProfile.FileName;
                        uProfile.SaveAs(Server.MapPath(imagePath));
                    }
                    cmd.Parameters.AddWithValue("@uProfile", imagePath);

                    if (uGender.SelectedItem == null)
                    {
                        lblMessage.Text = "Please select a gender!";
                        return;
                    }

                    cmd.Parameters.AddWithValue("@uGender", uGender.SelectedValue);
                    cmd.Parameters.AddWithValue("@uRole", "Customer");
                    cmd.Parameters.AddWithValue("@dtCreated", DateTime.Now);

                    cmd.ExecuteNonQuery();
                }
            }

            lblMessage.Text = uName.Text + "User Profile added successfully!";
            dtCreated.Text = DateTime.Now.ToString();

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
                    alertBox.innerText = 'Registration Successful';
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
                    alertBox.innerText = 'Registration Unsuccessful! Please try again.';
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

            ClearFields();
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
    }
}