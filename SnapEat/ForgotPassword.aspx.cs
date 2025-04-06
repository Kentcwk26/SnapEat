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
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            uEmail.Text = "";
            uPassword.Text = "";
            Response.Redirect("Default.aspx");
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string checkUserQuery = "SELECT uID FROM [User] WHERE uEmail = @uEmail OR uName = @uName";
                using (SqlCommand checkUserCmd = new SqlCommand(checkUserQuery, conn))
                {
                    checkUserCmd.Parameters.AddWithValue("@uEmail", uEmail.Text.Trim());
                    checkUserCmd.Parameters.AddWithValue("@uName", uName.Text.Trim());

                    object userId = checkUserCmd.ExecuteScalar();

                    if (userId == null)
                    {
                        ShowAlert("User not found. Please check your registered email or name.", "red");
                        return;
                    }
                }

                if (uPassword.Text.Trim() != confirmPassword.Text.Trim())
                {
                    ShowAlert("New Password and Confirm Password do not match!", "red");
                    return;
                }

                string updateQuery = "UPDATE [User] SET uPassword = @newPassword WHERE uEmail = @uEmail OR uName = @uName";
                using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
                {
                    updateCmd.Parameters.AddWithValue("@newPassword", uPassword.Text.Trim());
                    updateCmd.Parameters.AddWithValue("@uEmail", uEmail.Text.Trim());
                    updateCmd.Parameters.AddWithValue("@uName", uName.Text.Trim());

                    int rowsAffected = updateCmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        ShowAlertWithRedirect("User Password updated successfully!", "green", "Login.aspx", 2000);
                        return;
                    }
                    else
                    {
                        ShowAlert("Password update failed. Please try again later.", "red");
                    }
                }
            }
        }

        private void ShowAlertWithRedirect(string message, string color, string redirectUrl, int timeout)
        {
            string script = $@"
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
                    window.location.href = '{redirectUrl}';
                }}, {timeout});
            ";
            ClientScript.RegisterStartupScript(this.GetType(), "alertRedirectMessage", script, true);
        }


        private void ShowAlert(string message, string color)
        {
            string script = $@"
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
                setTimeout(function() {{ alertBox.remove(); }}, 3000);
            ";
            ClientScript.RegisterStartupScript(this.GetType(), "alertMessage", script, true);
        }
    }
}