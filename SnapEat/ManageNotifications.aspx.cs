using System;
using System.Web.UI.WebControls;

namespace SnapEat
{
    public partial class ManageNotifications : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ApplyFilters();
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            ApplyFilters();
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ApplyFilters();
        }

        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            ApplyFilters();
        }

        private void ApplyFilters()
        {
            string searchTerm = txtSearch.Text.Trim();
            string baseQuery = "SELECT * FROM [Notification]";
            string whereClause = "";
            string orderBy = "";

            if (!string.IsNullOrEmpty(searchTerm))
            {
                whereClause += " WHERE notification LIKE '%' + @SearchTerm + '%'";
                SqlDataSource1.SelectParameters.Clear();
                SqlDataSource1.SelectParameters.Add("SearchTerm", searchTerm);
            }

            switch (DropDownList1.SelectedValue)
            {
                case "Latest":
                    orderBy = " ORDER BY nID DESC";
                    break;
                case "Earliest":
                    orderBy = " ORDER BY nID ASC";
                    break;
                case "Generated":
                    if (string.IsNullOrEmpty(whereClause))
                        whereClause += " WHERE type = 'Generated'";
                    else
                        whereClause += " AND type = 'Generated'";
                    break;
            }

            SqlDataSource1.SelectCommand = baseQuery + whereClause + orderBy;
        }

        protected void gvCart_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ToggleEdit")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                gvCart.EditIndex = rowIndex;
            }
            else if (e.CommandName == "CancelEdit")
            {
                gvCart.EditIndex = -1;
            }
        }

        protected void gvCart_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Button btnEditUpdate = (Button)e.Row.FindControl("btnEditUpdate");
                Button btnCancel = (Button)e.Row.FindControl("Button3");

                if (gvCart.EditIndex == e.Row.RowIndex)
                {
                    btnEditUpdate.Text = "Update";
                    btnEditUpdate.CommandName = "UpdateRow";
                    btnCancel.Visible = true;
                }
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            SqlDataSource1.InsertParameters.Clear();
            SqlDataSource1.InsertCommand = "INSERT INTO Notification (uID, notification, type) VALUES (@uID, @notification, @type)";
            SqlDataSource1.InsertParameters.Add("uID", null);
            SqlDataSource1.InsertParameters.Add("notification", "To our honoured SnapEat customers, we hope you're enjoying our SnapEat website with the great experience");
            SqlDataSource1.InsertParameters.Add("type", "Generated");
            SqlDataSource1.Insert();
        }
    }
}
