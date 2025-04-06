<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageFProfile.aspx.cs" Inherits="SnapEat.ManageFProfile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="style.css" rel="stylesheet" type="text/css"/>
    <script>
        function previewImage(event) {
            var reader = new FileReader();
            reader.onload = function () {
                var output = document.getElementById('<%= Image1.ClientID %>');
                output.src = reader.result;
            }
            reader.readAsDataURL(event.target.files[0]);
        }
        function validateForm() {
            var name = document.getElementById('<%= fName.ClientID %>').value.trim();
            var desc = document.getElementById('<%= fDesc.ClientID %>').value.trim();
            var price = document.getElementById('<%= fPrice.ClientID %>').value.trim();
            var category = document.getElementById('<%= fCategory.ClientID %>').value;
            var image = document.getElementById('<%= fImage.ClientID %>').value;

            if (name === "") {
                alert("Food Name cannot be empty!");
                return false;
            }
            if (desc === "") {
                alert("Food Description cannot be empty!");
                return false;
            }
            if (price === "" || isNaN(price) || parseFloat(price) <= 0) {
                alert("Please enter a valid Price!");
                return false;
            }
            if (category === "Select") {
                alert("Please select a category!");
                return false;
            }
            if (image === "" && document.getElementById('<%= Image1.ClientID %>').src.includes("no-image.png")) {
                alert("Please upload an image!");
                return false;
            }
        }
        function validateImageFile(input) {
            var file = input.files[0];
            if (file) {
                var allowedExtensions = /(\.jpg|\.jpeg|\.png|\.gif)$/i;
                if (!allowedExtensions.test(file.name)) {
                    alert("Only image files (.jpg, .jpeg, .png, .gif) are allowed!");
                    input.value = ""; 
                    return false;
                }
                var reader = new FileReader();
                reader.onload = function () {
                    var output = document.getElementById('<%= Image1.ClientID %>');
                    output.src = reader.result;
                }
                reader.readAsDataURL(file);
            }
        }
    </script>
    <h2><strong>Manage Food</strong></h2>
    <div class="user-container">
        <div>
            <asp:Image ID="Image1" runat="server" width="300px" height="300px" style="margin: 10px 0;"/><br>
            <asp:FileUpload ID="fImage" runat="server" style="padding: 10px 26px;" onchange="validateImageFile(this)"/>
        </div>
        <div class="form-table">
            <table>
                <tr>
                    <td style="width: 200px;">Food ID</td>
                    <td><asp:Label ID="fID" runat="server" Text="FID"></asp:Label></td>
                </tr>
                <tr>
                    <td style="width: 200px;">Food Name</td>
                    <td><asp:TextBox ID="fName" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td style="width: 200px;">Food Description</td>
                    <td><asp:TextBox ID="fDesc" runat="server" TextMode="MultiLine" Width="1000px" Rows="2"></asp:TextBox></td>
                </tr>
                <tr>
                    <td style="width: 200px;">Food Category</td>
                    <td>
                        <asp:RadioButtonList ID="fCategory" runat="server" CssClass="radio-container">
                            <asp:ListItem>Food</asp:ListItem>
                            <asp:ListItem>Beverage</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px;">Food Price</td>
                    <td><asp:TextBox ID="fPrice" runat="server"></asp:TextBox></td>
                </tr>
            </table>
            <asp:Label ID="lblMessage" runat="server" Text="Label" Visible="False"></asp:Label><br>
        </div>
    </div>
    <div class="button-container">
        <asp:Button ID="btnAdd" runat="server" OnClick="btnAdd_Click" Text="Add" />
        <asp:Button ID="btnEdit" runat="server" Text="Edit" OnClientClick="return confirm('Are you sure you want to edit this item?');" OnClick="btnEdit_Click" />
        <asp:Button ID="btnDelete" runat="server" Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this item?');" OnClick="btnDelete_Click" />
        <asp:Button ID="btnCancel" runat="server" OnClientClick="history.back(); return false;" OnClick="btnCancel_Click" Text="Cancel" />
    </div>
    <br />
    <asp:GridView ID="GridView1" runat="server" AllowSorting="True" CssClass="GridViewStyle" AutoGenerateColumns="False" CellPadding="4" DataSourceID="SqlDataSource1" ForeColor="#333333" GridLines="None" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" DataKeyNames="FID" style="padding: 10px 0px; margin: 10px 0px;" AllowPaging="True">
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
        <Columns>
            <asp:CommandField ShowSelectButton="True" />
            <asp:BoundField DataField="FID" HeaderText="ID" ReadOnly="True" SortExpression="FID" InsertVisible="False" />
            <asp:BoundField DataField="fName" HeaderText="Name" SortExpression="fName" />
            <asp:BoundField DataField="fDesc" HeaderText="Description" SortExpression="fDesc" />
            <asp:BoundField DataField="fImage" HeaderText="Image" SortExpression="fImage" />
            <asp:BoundField DataField="fCategory" HeaderText="Category" SortExpression="fCategory" />
            <asp:BoundField DataField="fPrice" HeaderText="Price (RM)" SortExpression="fPrice" />
            <asp:BoundField DataField="dtCreated" HeaderText="Date Creation" SortExpression="dtCreated" />
        </Columns>
        <EditRowStyle BackColor="#999999" />
        <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
        <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
        <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
        <SortedAscendingCellStyle BackColor="#E9E7E2" />
        <SortedAscendingHeaderStyle BackColor="#506C8C" />
        <SortedDescendingCellStyle BackColor="#FFFDF8" />
        <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
    </asp:GridView>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [Food]">
    </asp:SqlDataSource>
    <asp:Label ID="lbldtRegistered" runat="server" Text="Label" Visible="False"></asp:Label>
    <br/>
</asp:Content>