<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ViewInformation.aspx.cs" Inherits="SnapEat.ViewInformation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="style.css" rel="stylesheet" type="text/css"/>
    <h2><strong>View Information</strong></h2>
    
    <div class="search-container">
        <div class="search-group">
            <asp:TextBox ID="txtSearch" runat="server" BorderColor="Black" Placeholder="Search User ...." CssClass="search"></asp:TextBox>
            <asp:Button ID="Button2" runat="server" Text="Clear" CssClass="search-btn" OnClick="Button2_Click"/>
            <asp:Button ID="Button1" runat="server" Text="Search" CssClass="search-btn" OnClick="Button1_Click"/>
        </div>
        <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" CssClass="dropdown" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged">
            <asp:ListItem Value="Default">All</asp:ListItem>
            <asp:ListItem Value="Customer">Customer</asp:ListItem>
            <asp:ListItem Value="Staff">Staff</asp:ListItem>
            <asp:ListItem Value="Admin">Admin</asp:ListItem>
        </asp:DropDownList>
    </div>
    
    <div class="center-container">
        <asp:DataList ID="DataList1" runat="server" CellPadding="4" DataKeyField="uID" DataSourceID="SqlDataSource1" ForeColor="#333333" RepeatColumns="4">
            <AlternatingItemStyle BackColor="White" />
            <FooterStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <ItemStyle BackColor="#E3EAEB" />
            <ItemTemplate>
                <asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("uProfile") %>' style="width: 250px; height: 250px;"/>
                <br>
                <br />
                <asp:Label ID="formatted_uIDLabel" runat="server" Text='<%# Eval("formatted_uID") %>' />
                <br />
                <br />
                <asp:Label ID="uNameLabel" runat="server" Text='<%# Eval("uName") %>' />
                <br />
                <asp:Label ID="uEmailLabel" runat="server" Text='<%# Eval("uEmail") %>' />
                <br />
                <asp:Label ID="uContactLabel" runat="server" Text='<%# Eval("uContact") %>' />
                <br />
                <br />
                Date Created:
                <br />
                <asp:Label ID="dtCreatedLabel" runat="server" Text='<%# Eval("dtCreated") %>' />
                <br />
            </ItemTemplate>
            <SelectedItemStyle BackColor="#C5BBAF" Font-Bold="True" ForeColor="#333333" />
        </asp:DataList>
    </div>

    <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClientClick="history.back(); return false;"/>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        SelectCommand="SELECT * FROM [User]" DeleteCommand="DELETE FROM [User] WHERE [uID] = @uID" InsertCommand="INSERT INTO [User] ([dtCreated], [uName], [uGender], [uProfile], [uEmail], [uPassword], [uContact], [uBirthday], [uRole], [formatted_uID]) VALUES (@dtCreated, @uName, @uGender, @uProfile, @uEmail, @uPassword, @uContact, @uBirthday, @uRole, @formatted_uID)" UpdateCommand="UPDATE [User] SET [dtCreated] = @dtCreated, [uName] = @uName, [uGender] = @uGender, [uProfile] = @uProfile, [uEmail] = @uEmail, [uPassword] = @uPassword, [uContact] = @uContact, [uBirthday] = @uBirthday, [uRole] = @uRole, [formatted_uID] = @formatted_uID WHERE [uID] = @uID">
        <DeleteParameters>
            <asp:Parameter Name="uID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter DbType="Date" Name="dtCreated" />
            <asp:Parameter Name="uName" Type="String" />
            <asp:Parameter Name="uGender" Type="String" />
            <asp:Parameter Name="uProfile" Type="String" />
            <asp:Parameter Name="uEmail" Type="String" />
            <asp:Parameter Name="uPassword" Type="String" />
            <asp:Parameter Name="uContact" Type="String" />
            <asp:Parameter DbType="Date" Name="uBirthday" />
            <asp:Parameter Name="uRole" Type="String" />
            <asp:Parameter Name="formatted_uID" Type="String" />
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
            <asp:Parameter Name="formatted_uID" Type="String" />
            <asp:Parameter Name="uID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>

</asp:Content>