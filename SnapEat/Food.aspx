<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Food.aspx.cs" Inherits="SnapEat.Food" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="style.css" rel="stylesheet" type="text/css"/>
    <h2><strong>Food Catalog</strong></h2><br>
    <div class="search-container">
        <div class="search-group">
            <asp:TextBox ID="txtSearch" runat="server" BorderColor="Black" Placeholder="Search Anything ...." CssClass="search"></asp:TextBox>
            <asp:Button ID="Button2" runat="server" Text="Clear" CssClass="search-btn" OnClick="Button2_Click"/>
            <asp:Button ID="Button1" runat="server" Text="Search" CssClass="search-btn" OnClick="Button1_Click"/>
        </div>
        <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" CssClass="dropdown" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged">
            <asp:ListItem Value="Default">All</asp:ListItem>
            <asp:ListItem Value="Food">Food</asp:ListItem>
            <asp:ListItem Value="Beverage">Beverage</asp:ListItem>
        </asp:DropDownList>
    </div>
    <asp:DataList ID="DataList1" runat="server" DataSourceID="SqlDataSource1" RepeatColumns="5" ShowFooter="False" CssClass="list">
        <ItemTemplate>
            <br>
            <asp:Image ID="fImageLabel" runat="server" ImageUrl='<%# Eval("fImage") %>' style="width: 250px; height: 250px;"/>
            <br>
            <br>
            <asp:Label ID="fNameLabel" runat="server" Text='<%# Eval("fName") %>' Font-Bold="true" Font-Size="20px"/>
            <br />
            <asp:Label ID="fPriceLabel" runat="server" Text='<%# "RM" + Eval("fPrice", "{0:0.00}") %>' />
            <br />
            <br>
            <asp:Button ID="btnDetails" runat="server" Text="Details" CommandArgument='<%# Eval("fID") %>' OnClick="btnDetails_Click" />
            <br />
            <br>
        </ItemTemplate>
    </asp:DataList>
    <br>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [Food]"></asp:SqlDataSource>
    <br>
</asp:Content>