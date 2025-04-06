<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageOrders.aspx.cs" Inherits="SnapEat.ManageOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="style.css" rel="stylesheet" type="text/css"/>
    <h2><strong>Manage Orders</strong></h2>
    
    <div class="search-container">
        <div class="search-group">
            <asp:TextBox ID="txtSearch" runat="server" BorderColor="Black" Placeholder="Search Orders ...." CssClass="search"></asp:TextBox>
            <asp:Button ID="Button2" runat="server" Text="Clear" CssClass="search-btn" OnClick="Button2_Click"/>
            <asp:Button ID="Button1" runat="server" Text="Search" CssClass="search-btn" OnClick="Button1_Click"/>
        </div>
        <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" CssClass="dropdown" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged">
            <asp:ListItem Value="Default">All</asp:ListItem>
            <asp:ListItem Value="Pending">Pending Orders</asp:ListItem>
            <asp:ListItem Value="Completed">Completed Orders</asp:ListItem>
            <asp:ListItem Value="Latest">Sort by latest orders</asp:ListItem>
            <asp:ListItem Value="Earliest">Sort by earliest orders</asp:ListItem>
            <asp:ListItem Value="PaymentCompleted">Sort by payment completed</asp:ListItem>
            <asp:ListItem Value="PendingPayment">Sort by pending payment</asp:ListItem>
            <asp:ListItem Value="DeliveryCompleted">Sort by delivery completed</asp:ListItem>
            <asp:ListItem Value="PendingDelivery">Sort by pending delivery</asp:ListItem>
        </asp:DropDownList>
    </div>
    
    <div class="center-container">
        <div class="gridview-container">
            <asp:GridView ID="gvCart" runat="server" CssClass="aspNetGrid" AllowPaging="True" AutoGenerateColumns="False" 
                CellPadding="4" DataKeyNames="oID" DataSourceID="SqlDataSource1" ForeColor="#333333" GridLines="None"
                OnRowCommand="gvCart_RowCommand" OnRowDataBound="gvCart_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="formatted_oID" HeaderText="Order ID" ReadOnly="True" />
                    <asp:BoundField DataField="dtCreated" HeaderText="Date Created" ReadOnly="True" />
                    <asp:BoundField DataField="fName" HeaderText="Food Name" ReadOnly="True" />

                    <asp:TemplateField HeaderText="Food Price">
                        <ItemTemplate>
                            RM<%# String.Format("{0:0.00}", Eval("price")) %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Payment Status">
                        <ItemTemplate>
                            <asp:Label ID="lblPaymentStatus" runat="server" Text='<%# Eval("paymentStatus") %>'></asp:Label>
                            <asp:DropDownList ID="ddlPaymentStatus" runat="server" Visible="false">
                                <asp:ListItem Text="Pending" Value="Pending" />
                                <asp:ListItem Text="Failed" Value="Failed" />
                                <asp:ListItem Text="Completed" Value="Completed" />
                                <asp:ListItem Text="Cancelled" Value="Cancelled" />
                            </asp:DropDownList>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Delivery Status">
                        <ItemTemplate>
                            <asp:Label ID="lblDeliveryStatus" runat="server" Text='<%# Eval("deliveryStatus") %>'></asp:Label>
                            <asp:DropDownList ID="ddlDeliveryStatus" runat="server" Visible="false">
                                <asp:ListItem Text="Pending" Value="Pending" />
                                <asp:ListItem Text="Failed" Value="Failed" />
                                <asp:ListItem Text="Processing" Value="Processing" />
                                <asp:ListItem Text="Completed" Value="Completed" />
                            </asp:DropDownList>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:Button ID="btnEditUpdate" runat="server" CssClass="btn-danger" Text="Edit" CommandName="ToggleEdit" CommandArgument='<%# Eval("oID") %>' />
                            <asp:Button ID="btnCancel" runat="server" CssClass="btn-secondary" Text="Cancel" CommandName="CancelEdit" CommandArgument='<%# Eval("oID") %>' Visible="false" />
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>
        </div>
    </div>

    <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClientClick="history.back(); return false;"/>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        SelectCommand="SELECT O.oID, O.dtCreated, F.fName, O.quantity, O.price, O.paymentStatus, O.deliveryStatus, O.formatted_oID,
                       FROM [Order] AS O INNER JOIN Food AS F ON O.fID = F.fID">
    </asp:SqlDataSource>

</asp:Content>