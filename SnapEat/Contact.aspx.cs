using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace SnapEat
{
    public partial class Contact : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Session["uID"] == null)
            {
                string errorScript = @"
                var alertBox = document.createElement('div');
                alertBox.innerText = 'You should login or register an account first in order to give feedback'; 
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
                return;
            }

            string userID = Session["uID"].ToString();
            string feedback = txtMessage.Text.Trim();

            if (string.IsNullOrEmpty(feedback))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "inputError", "alert('Feedback cannot be empty!');", true);
                return;
            }

            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();

                    string query = "INSERT INTO Feedback (uID, feedback) VALUES (@uID, @feedback)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@uID", userID);
                        cmd.Parameters.AddWithValue("@feedback", feedback);
                        cmd.ExecuteNonQuery();
                    }

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
                    alertBox.innerText = 'Thank you for giving us your feedback'; 
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
                    ClientScript.RegisterStartupScript(this.GetType(), "successAlert", script, true);

                    txtMessage.Text = "";
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "dbError", $"alert('Error: {ex.Message}');", true);
                }
            }
        }
    }
}