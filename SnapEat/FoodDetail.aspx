<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="FoodDetail.aspx.cs" Inherits="SnapEat.FoodDetail" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="style.css" rel="stylesheet" type="text/css"/> 
    <div style="display: flex; height: 400px; align-items: flex-start; gap: 20px;">
        <div>
            <asp:Image ID="Image1" runat="server" style="height: 300px; width: 300px; padding: 20px 0;"/>
        </div>
        <div>
            <table style="text-align: left">
                <tr>
                    <td>
                        <asp:Label ID="lblFoodName" runat="server" Font-Bold="true" Font-Size="36px"/>
                        <span style="display:inline-block; width: 20px;"></span>
                        <asp:Label ID="lblFoodPrice" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td style="padding: 20px 0px; height: 62px;"><asp:Label ID="lblDescription" runat="server" /></td>
                </tr>
                <tr>
                    <td>
                        <strong>Quantity:</strong>
                        <span style="display:inline-block; width: 10px;"></span>
                        <asp:TextBox ID="txtQuantity" runat="server" Text="1" Width="50px" type="number" min="1" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <strong>Category:</strong>
                        <span style="display:inline-block; width: 10px;"></span>
                        <asp:Label ID="lblCategory" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td style="padding: 20px 0;">
                        <asp:LinkButton ID="btnAddToCart" runat="server" OnClick="btnAddToCart_Click">Add to Cart</asp:LinkButton>
                    </td>
                </tr>
                <tr>
                    <td style="padding-top: 20px;">
                        <asp:Button ID="btnSubmit" runat="server" Text="Submit Order" OnClick="btnSubmit_Click" />
                        <span style="display:inline-block; width: 4px;"></span>
                        <asp:Button ID="btnLoginRegister" runat="server" Text="Please login / register to order food" PostBackUrl="~/Login.aspx"/>
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClientClick="history.back(); return false;" CssClass="btn-danger" PostBackUrl="~/Food.aspx"/>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <h5 style="text-align: left;">You may also like ....</h5>
<%--    <div class="repeater-container">
        <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource1">
            <ItemTemplate>
                <div class="list-item">
                    <asp:Image ID="fImageLabel" runat="server" ImageUrl='<%# Eval("fImage") %>' style="width: 230px; height: 250px;"/>
                    <br><br>
                    <asp:Label ID="fNameLabel" runat="server" Text='<%# Eval("fName") %>' Font-Bold="true" Font-Size="24px"/>
                    <br />
                    <asp:Label ID="fPriceLabel" runat="server" Text='<%# "RM" + Eval("fPrice", "{0:0.00}") %>' />
                    <br><br>
                    <asp:Button ID="btnDetails" runat="server" Text="Details" CommandArgument='<%# Eval("fID") %>' OnClick="btnDetails_Click" />
                    <br><br>
                </div>
            </ItemTemplate>
            <SeparatorTemplate></SeparatorTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [Food]"></asp:SqlDataSource>
    </div>--%>
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
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [Food] WHERE fID <> @SelectedFoodID">
        <SelectParameters>
            <asp:SessionParameter Name="SelectedFoodID" SessionField="SelectedFoodID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" DeleteCommand="DELETE FROM [Cart] WHERE [cID] = @cID" InsertCommand="INSERT INTO [Cart] ([uID], [fID], [quantity]) VALUES (@uID, @fID, @quantity)" SelectCommand="SELECT * FROM [Cart]" UpdateCommand="UPDATE [Cart] SET [uID] = @uID, [fID] = @fID, [quantity] = @quantity WHERE [cID] = @cID">
        <DeleteParameters>
            <asp:Parameter Name="cID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="uID" Type="Int32" />
            <asp:Parameter Name="fID" Type="Int32" />
            <asp:Parameter Name="quantity" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="uID" Type="Int32" />
            <asp:Parameter Name="fID" Type="Int32" />
            <asp:Parameter Name="quantity" Type="String" />
            <asp:Parameter Name="cID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
</asp:Content>