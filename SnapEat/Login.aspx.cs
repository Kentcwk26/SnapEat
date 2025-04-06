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
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string query = "SELECT uID, uName, uRole FROM [User] WHERE uEmail=@uEmail AND uPassword=@uPassword";
                using (SqlCommand comm = new SqlCommand(query, conn))
                {
                    comm.Parameters.AddWithValue("@uEmail", uEmail.Text.Trim());
                    comm.Parameters.AddWithValue("@uPassword", uPassword.Text.Trim());

                    using (SqlDataReader reader = comm.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            Session["uID"] = reader["uID"].ToString();
                            Session["uName"] = reader["uName"].ToString();
                            Session["uRole"] = reader["uRole"].ToString();
                            string userRole = Session["uRole"].ToString();

                            string homeUrl = "default.aspx";

                            switch (userRole)
                            {
                                case "Admin":
                                    homeUrl = "Admin_Dashboard.aspx";
                                    break;
                                case "Staff":
                                    homeUrl = "Staff_Dashboard.aspx";
                                    break;
                                case "Customer":
                                    homeUrl = "default.aspx";
                                    break;
                            }

                            Session["HomeUrl"] = homeUrl;

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
                                alertBox.innerText = 'Login Successful';
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
                                setTimeout(function() {{ alertBox.remove(); window.location.href = '{homeUrl}'; }}, 2000);
                            ";
                            ClientScript.RegisterStartupScript(this.GetType(), "autoCloseAlert", script, true);
                        }
                        else
                        {
                            string script = @"
                                var alertBox = document.createElement('div');
                                alertBox.innerText = 'Login Unsuccessful, please try again or register a new account';
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
                            ClientScript.RegisterStartupScript(this.GetType(), "autoCloseAlert", script, true);
                        }
                    }
                }
            }
        }
    }
}