<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SA_Registration.aspx.cs" Inherits="SnapEat.SA_Registration" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
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
                toggleIcon.classList.remove("fa-eye");
                toggleIcon.classList.add("fa-eye-slash");
            } else {
                passwordField.type = "password";
                toggleIcon.classList.remove("fa-eye-slash");
                toggleIcon.classList.add("fa-eye");
            }
        }
    </script>
    <h2><strong>Registration</strong></h2>
    <div style="display: flex; align-items: flex-start; gap: 20px;">
        <div>
            <asp:Image ID="Image1" runat="server" width="230px" height="250px"/><br/>
            <asp:FileUpload ID="uProfile" runat="server" style="padding: 10px 26px;" onChange="previewImage(event)"/>
        </div>
        <div class="form-table">
            <table>
                <tr>
                    <td style="width: 200px;">User ID</td>
                    <td>
                        <asp:Label ID="uID" runat="server" Text="uID"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px;">Full Name</td>
                    <td>
                        <asp:TextBox ID="uName" runat="server" Width="800px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px;">Gender</td>
                    <td>
                        <asp:RadioButtonList ID="uGender" runat="server" Width="205px">
                            <asp:ListItem>Male</asp:ListItem>
                            <asp:ListItem>Female</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px;">Contact Number</td>
                    <td>
                        <asp:TextBox ID="uContact" runat="server" Width="800px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px;">Email Address</td>
                    <td>
                        <asp:TextBox ID="uEmail" runat="server" Width="800px" TextMode="Email"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px;">Password</td>
                    <td>
                        <asp:TextBox ID="uPassword" runat="server" Width="800px"></asp:TextBox>
                        <i id="togglePassword" class="fa-solid fa-eye" onclick="togglePasswordVisibility()" style="cursor: pointer;"></i>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px;">Birthday</td>
                    <td>
                        <asp:TextBox ID="uBirthday" runat="server" Width="800px" TextMode="Date"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px;">Role</td>
                    <td>
                        <asp:RadioButtonList ID="uRole" runat="server" Width="205px">
                            <asp:ListItem>Staff</asp:ListItem>
                            <asp:ListItem>Admin</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <asp:Button ID="Button1" runat="server" Text="Register" OnClick="Button1_Click" />
    <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClientClick="history.back(); return false;"/>
    &nbsp;<asp:Label ID="dtCreated" runat="server" Text="Label" Visible="False"></asp:Label><br>
    <asp:Label ID="lblMessage" runat="server" Text="Label" Visible="False"></asp:Label>
<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [User]" DeleteCommand="DELETE FROM [User] WHERE [uID] = @uID" InsertCommand="INSERT INTO [User] ([dtCreated], [uName], [uGender], [uProfile], [uEmail], [uPassword], [uContact], [uBirthday], [uRole]) VALUES (@dtCreated, @uName, @uGender, @uProfile, @uEmail, @uPassword, @uContact, @uBirthday, @uRole)" UpdateCommand="UPDATE [User] SET [dtCreated] = @dtCreated, [uName] = @uName, [uGender] = @uGender, [uProfile] = @uProfile, [uEmail] = @uEmail, [uPassword] = @uPassword, [uContact] = @uContact, [uBirthday] = @uBirthday, [uRole] = @uRole WHERE [uID] = @uID">
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
        <asp:Parameter DbType="Date" Name="uBirthday" />
        <asp:Parameter Name="uRole" Type="String" />
    </InsertParameters>
    <UpdateParameters>
        <asp:Parameter DbType="Date" Name="dtCreated" />
        <asp:Parameter Name="uName" Type="String" />
        <asp:Parameter Name="uGender" Type="String" />
        <asp:Parameter Name="uProfile" Type="String" />
        <asp:Parameter Name="uEmail" Type="String" />
        <asp:Parameter Name="uPassword" Type="String" />
        <asp:Parameter Name="uContact" Type="String" />
        <asp:Parameter DbType="Date" Name="uBirthday" />
        <asp:Parameter Name="uRole" Type="String" />
        <asp:Parameter Name="uID" Type="Int32" />
    </UpdateParameters>
    </asp:SqlDataSource>
</asp:Content>