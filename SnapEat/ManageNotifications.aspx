<%@ Page Title="Manage Notifications" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageNotifications.aspx.cs" Inherits="SnapEat.ManageNotifications" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="style.css" rel="stylesheet" type="text/css"/>
    <h2><strong>Manage Notifications</strong></h2>
    
    <div class="search-container">
        <div class="search-group">
            <asp:TextBox ID="txtSearch" runat="server" BorderColor="Black" Placeholder="Search Notifications ...." CssClass="search"></asp:TextBox>
            <asp:Button ID="Button2" runat="server" Text="Clear" CssClass="search-btn" OnClick="Button2_Click"/>
            <asp:Button ID="Button1" runat="server" Text="Search" CssClass="search-btn" OnClick="Button1_Click"/>
        </div>
        <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" CssClass="dropdown" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged">
            <asp:ListItem Value="Default">All</asp:ListItem>
            <asp:ListItem Value="Generate">Generated Notification</asp:ListItem>
            <asp:ListItem Value="Latest">Sort by latest notifications</asp:ListItem>
            <asp:ListItem Value="Earliest">Sort by earliest notifications</asp:ListItem>
        </asp:DropDownList>
    </div>
    
    <div class="center-container">
        <div class="gridview-container">
            <asp:GridView ID="gvCart" runat="server" CssClass="aspNetGrid" AllowPaging="True" AutoGenerateColumns="False" 
                CellPadding="4" DataKeyNames="nID" DataSourceID="SqlDataSource1" ForeColor="#333333" GridLines="None"
                OnRowCommand="gvCart_RowCommand" OnRowDataBound="gvCart_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="formatted_nID" HeaderText="Notification ID" ReadOnly="True" SortExpression="formatted_nID" />
                    <asp:BoundField DataField="notification" HeaderText="Notification" SortExpression="notification" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:Button ID="btnEditUpdate" runat="server" CssClass="btn-danger" Text="Edit" CommandName="ToggleEdit" CommandArgument='<%# Eval("nID") %>' />
                            <asp:Button ID="Button3" runat="server" CssClass="btn-secondary" Text="Cancel" CommandName="CancelEdit" CommandArgument='<%# Eval("nID") %>' Visible="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <asp:Button ID="btnAdd" runat="server" Text="Add Notification" OnClick="btnAdd_Click"/>
    <asp:Button ID="btnCancel" runat="server" Text="Cancel" postbackUrl="~/Admin_Dashboard.aspx"/>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        SelectCommand="SELECT * FROM [Notification]" DeleteCommand="DELETE FROM [Notification] WHERE [nID] = @nID" InsertCommand="INSERT INTO [Notification] ([uID], [notification], [type], [formatted_nID]) VALUES (@uID, @notification, @type, @formatted_nID)" UpdateCommand="UPDATE [Notification] SET [uID] = @uID, [notification] = @notification, [type] = @type, [formatted_nID] = @formatted_nID WHERE [nID] = @nID">
        <DeleteParameters>
            <asp:Parameter Name="nID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="uID" Type="String" />
            <asp:Parameter Name="notification" Type="String" />
            <asp:Parameter Name="type" Type="String" />
            <asp:Parameter Name="formatted_nID" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="uID" Type="String" />
            <asp:Parameter Name="notification" Type="String" />
            <asp:Parameter Name="type" Type="String" />
            <asp:Parameter Name="formatted_nID" Type="String" />
            <asp:Parameter Name="nID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>

</asp:Content>