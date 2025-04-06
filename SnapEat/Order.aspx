<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Order.aspx.cs" Inherits="SnapEat.Order" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="style.css" rel="stylesheet" type="text/css"/>
    <h2><strong>Your Orders</strong></h2>
    <div class="search-container">
        <div class="search-group">
            <asp:TextBox ID="txtSearch" runat="server" BorderColor="Black" Placeholder="Search Anything ...." CssClass="search"></asp:TextBox>
            <asp:Button ID="Button2" runat="server" Text="Clear" CssClass="search-btn" OnClick="Button2_Click"/>
            <asp:Button ID="Button1" runat="server" Text="Search" CssClass="search-btn" OnClick="Button1_Click"/>
        </div>
        <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" CssClass="dropdown" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged">
            <asp:ListItem Value="Default">All</asp:ListItem>
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
            <asp:Label ID="lblNoData" runat="server" ForeColor="Red" Visible="False"></asp:Label>
            <asp:GridView ID="GridView1" CssClass="aspNetGrid" runat="server" AutoGenerateColumns="False" CellPadding="4" DataKeyNames="oID" DataSourceID="SqlDataSource1" ForeColor="#333333" GridLines="None">
            <AlternatingRowStyle BackColor="White" />
            <Columns>
                <asp:BoundField DataField="oID" HeaderText="Order ID" InsertVisible="False" ReadOnly="True" SortExpression="oID" />
                <asp:BoundField DataField="dtCreated" HeaderText="Date Creation" SortExpression="dtCreated" />
                <asp:BoundField DataField="FoodName" HeaderText="Food Name" SortExpression="FoodName" />
                <asp:BoundField DataField="quantity" HeaderText="Order Quantity" SortExpression="quantity" />
                <asp:BoundField DataField="price" HeaderText="Food Price" SortExpression="price" />
                <asp:BoundField DataField="paymentStatus" HeaderText="Payment Status" SortExpression="paymentStatus" />
                <asp:BoundField DataField="deliveryStatus" HeaderText="Delivery Status" SortExpression="deliveryStatus" />
            </Columns>
            <EditRowStyle BackColor="#2461BF" />
            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
            <RowStyle BackColor="#EFF3FB" />
            <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
            <SortedAscendingCellStyle BackColor="#F5F7FB" />
            <SortedAscendingHeaderStyle BackColor="#6D95E1" />
            <SortedDescendingCellStyle BackColor="#E9EBEF" />
            <SortedDescendingHeaderStyle BackColor="#4870BE" />
        </asp:GridView>
        </div>
    </div>
    <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClientClick="history.back(); return false;"/>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
            SelectCommand="SELECT o.oID, o.dtCreated, f.fName AS FoodName, o.quantity, o.price, o.paymentStatus, o.deliveryStatus FROM [Order] o JOIN [Food] f ON o.fID = f.fID WHERE o.uID = @uID"
            DeleteCommand="DELETE FROM [Order] WHERE oID = @oID"
            InsertCommand="INSERT INTO [Order] (dtCreated, uID, fID, quantity, price, paymentStatus, deliveryStatus) 
                           VALUES (@dtCreated, @uID, @fID, @quantity, @price, @paymentStatus, @deliveryStatus)"
            UpdateCommand="UPDATE [Order] SET dtCreated = @dtCreated, uID = @uID, fID = @fID, quantity = @quantity, 
                           price = @price, paymentStatus = @paymentStatus, deliveryStatus = @deliveryStatus WHERE oID = @oID">
            <SelectParameters>
                <asp:SessionParameter Name="uID" SessionField="uID" Type="Int32" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="oID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="dtCreated" Type="String" />
                <asp:Parameter Name="uID" Type="Int32" />
                <asp:Parameter Name="fID" Type="Int32" />
                <asp:Parameter Name="quantity" Type="Int32" />
                <asp:Parameter Name="price" Type="Decimal" />
                <asp:Parameter Name="paymentStatus" Type="String" />
                <asp:Parameter Name="deliveryStatus" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="dtCreated" Type="String" />
                <asp:Parameter Name="uID" Type="Int32" />
                <asp:Parameter Name="fID" Type="Int32" />
                <asp:Parameter Name="quantity" Type="Int32" />
                <asp:Parameter Name="price" Type="Decimal" />
                <asp:Parameter Name="paymentStatus" Type="String" />
                <asp:Parameter Name="deliveryStatus" Type="String" />
                <asp:Parameter Name="oID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
    <br>
</asp:Content>