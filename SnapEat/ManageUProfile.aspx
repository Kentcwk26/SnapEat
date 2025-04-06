<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageUProfile.aspx.cs" Inherits="SnapEat.ManageUProfile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="style.css" rel="stylesheet" type="text/css"/>
    <script>
        window.onload = function () {
            var passwordField = document.getElementById('<%= uPassword.ClientID %>');
            if (passwordField) {
                passwordField.setAttribute("type", "password");
            }
        };
        function previewImage(event) {
            var reader = new FileReader();
            reader.onload = function () {
                var output = document.getElementById('<%= Image1.ClientID %>');
                output.src = reader.result;
            }
            reader.readAsDataURL(event.target.files[0]);
        }
        function validateForm() {
            var name = document.getElementById('<%= uName.ClientID %>').value.trim();
            var contact = document.getElementById('<%= uContact.ClientID %>').value.trim();
            var email = document.getElementById('<%= uEmail.ClientID %>').value.trim();
            var password = document.getElementById('<%= uPassword.ClientID %>').value.trim();
            var birthday = document.getElementById('<%= uBirthday.ClientID %>').value;
            if (name === "") {
                alert("Name cannot be empty!");
                return false;
            }
            if (contact === "" || isNaN(contact) || contact.length < 11) {
                alert("Please enter a valid Contact Number!");
                return false;
            }
            if (email === "" || !email.includes("@")) {
                alert("Please enter a valid Email Address!");
                return false;
            }
            if (password === "" || password.length < 6) {
                alert("Password must be at least 6 characters long!");
                return false;
            }
            if (birthday === "") {
                alert("Please enter a valid Birthday!");
                return false;
            }
            return true;
        }
        function togglePasswordVisibility() {
            var passwordField = document.getElementById('<%= uPassword.ClientID %>');
            var toggleIcon = document.getElementById("togglePassword");

            if (passwordField.type === "password") {
                passwordField.type = "text";
                toggleIcon.classList.remove("fa-eye-slash");
                toggleIcon.classList.add("fa-eye");
            } else {
                passwordField.type = "password";
                toggleIcon.classList.remove("fa-eye");
                toggleIcon.classList.add("fa-eye-slash");
            }
        }
    </script>
    <div class="item-container">
        <h2><strong>Manage User</strong></h2>
        <div class="right-item">
            <asp:Button ID="btnLogOut" runat="server" OnClick="Button1_Click" OnClientClick="return confirm('Are you sure you want to log out?');" Text="Log Out" CssClass="btn-danger"/>
        </div>
    </div>
    <div class="user-container">
        <div>
            <asp:Image ID="Image1" runat="server" width="230px" height="250px"/><br/>
            <asp:FileUpload ID="uProfile" runat="server" style="padding: 10px 26px;" onChange="previewImage(event)"/>
        </div>
        <div class="form-table">
            <table>
                <tr>
                    <td style="width: 200px;">Full Name</td>
                    <td><asp:TextBox ID="uName" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td style="width: 200px;">Gender</td>
                    <td>
                        <asp:RadioButtonList ID="uGender" runat="server">
                            <asp:ListItem>Male</asp:ListItem>
                            <asp:ListItem>Female</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px;">Contact Number</td>
                    <td><asp:TextBox ID="uContact" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td style="width: 200px;">Email Address</td>
                    <td><asp:TextBox ID="uEmail" runat="server" TextMode="Email"></asp:TextBox></td>
                </tr>
                <tr>
                    <td style="width: 200px;">Password</td>
                    <td>
                        <asp:TextBox ID="uPassword" runat="server"></asp:TextBox>
                        <i id="togglePassword" class="fa-solid fa-eye-slash" onclick="togglePasswordVisibility()" style="cursor: pointer;"></i>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px;">Birthday</td>
                    <td><asp:TextBox ID="uBirthday" runat="server" TextMode="Date"></asp:TextBox></td>
                </tr>
            </table>
                <asp:Label ID="lblMessage" runat="server" Text="Label" Visible="False"></asp:Label><br>
        </div>
    </div>
    <div class="button-container">
        <asp:Button ID="btnUpdate" runat="server" Text="Update" OnClientClick="return confirm('Are you sure you want to update this item?');" OnClick="BtnUpdate_Click"/>
        <asp:Button ID="btnDelete" runat="server" Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this item?');" OnClick="BtnDelete_Click"/>
        <asp:Button ID="btnCancel" runat="server" OnClick="BtnCancel_Click" Text="Cancel" />
    </div>
    &nbsp;<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [User]" DeleteCommand="DELETE FROM [User] WHERE [uID] = @uID" InsertCommand="INSERT INTO [User] ([dtCreated], [uName], [uGender], [uProfile], [uEmail], [uPassword], [uContact], [uBirthday], [uRole]) VALUES (@dtCreated, @uName, @uGender, @uProfile, @uEmail, @uPassword, @uContact, @uBirthday, @uRole)" UpdateCommand="UPDATE [User] SET [dtCreated] = @dtCreated, [uName] = @uName, [uGender] = @uGender, [uProfile] = @uProfile, [uEmail] = @uEmail, [uPassword] = @uPassword, [uContact] = @uContact, [uBirthday] = @uBirthday, [uRole] = @uRole WHERE [uID] = @uID">
        <DeleteParameters>
            <asp:Parameter Name="uID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="dtCreated" DbType="Date" />
            <asp:Parameter Name="uName" Type="String" />
            <asp:Parameter Name="uGender" Type="String" />
            <asp:Parameter Name="uProfile" Type="String" />
            <asp:Parameter Name="uEmail" Type="String" />
            <asp:Parameter Name="uPassword" Type="String" />
            <asp:Parameter Name="uContact" Type="String" />
            <asp:Parameter Name="uBirthday" DbType="Date" />
            <asp:Parameter Name="uRole" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="dtCreated" DbType="Date" />
            <asp:Parameter Name="uName" Type="String" />
            <asp:Parameter Name="uGender" Type="String" />
            <asp:Parameter Name="uProfile" Type="String" />
            <asp:Parameter Name="uEmail" Type="String" />
            <asp:Parameter Name="uPassword" Type="String" />
            <asp:Parameter Name="uContact" Type="String" />
            <asp:Parameter Name="uBirthday" DbType="Date" />
            <asp:Parameter Name="uRole" Type="String" />
            <asp:Parameter Name="uID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
</asp:Content>