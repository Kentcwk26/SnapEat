<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="SnapEat.Cart" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="style.css" rel="stylesheet" type="text/css"/> 
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            text-align: center;
        }

        h2 {
            padding: 20px 0;
            color: #333;
            font-size: 28px;
        }

        .centered-form {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
        }

        .cart-table {
            width: 80%;
            border-collapse: collapse;
            margin: 20px 0;
            background-color: white;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            padding: 15px;
            text-align: center;
        }

        th {
            background-color: #007bff;
            color: white;
            font-size: 18px;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #ddd;
        }

        .btn-action {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 6px 10px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            transition: background 0.3s ease;
        }

        .btn-remove {
            background-color: #ff4d4d !important;
        }

        .btn-action:hover {
            background-color: #218838;
        }

        .btn-remove:hover {
            background-color: #cc0000;
        }

        h3 {
            font-size: 22px;
            color: #444;
            margin-top: 10px;
        }

        #btnCheckout {
            background-color: #007bff !important;
            color: white;
            padding: 12px 25px;
            border: none;
            font-size: 18px;
            cursor: pointer;
            border-radius: 5px;
            margin-top: 10px;
            transition: background 0.3s ease;
        }

        #btnCheckout:hover {
            background-color: #0056b3;
        }
    </style>

    <h2><strong>Your Cart</strong></h2>

    <div class="center-container">
        <div class="gridview-container">
        <asp:Label ID="lblNoData" runat="server" ForeColor="Red" Visible="False"></asp:Label>
        <asp:GridView ID="gvCart" CssClass="aspNetGrid" runat="server" AutoGenerateColumns="False"
            CellPadding="4" DataSourceID="SqlDataSource1" ForeColor="#333333" GridLines="None"
            DataKeyNames="cID" OnRowCommand="GvCart_RowCommand">
                <Columns>
                    <asp:BoundField DataField="formatted_cID" HeaderText="formatted_cID" ReadOnly="True" SortExpression="formatted_cID" />
                    <asp:BoundField DataField="fName" HeaderText="Food Name" ReadOnly="True" SortExpression="fName" />
                    <asp:TemplateField HeaderText="Quantity">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnDecrease" runat="server" CssClass="btn-link" 
                                CommandName="Decrease" CommandArgument='<%# Convert.ToString(Eval("cID")) %>'>
                                &#8722;
                            </asp:LinkButton>

                            <asp:TextBox ID="txtQuantity" runat="server" CssClass="quantity-box" 
                                Text='<%# Eval("quantity") %>' ReadOnly="true" />

                            <asp:LinkButton ID="btnIncrease" runat="server" CssClass="btn-link" 
                                CommandName="Increase" CommandArgument='<%# Convert.ToString(Eval("cID")) %>'>
                                &#43;
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Price">
                        <ItemTemplate>
                            RM <asp:Label ID="lblPrice" runat="server" Text='<%# Eval("fPrice") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:Button ID="btnRemove" runat="server" Text="Remove" CssClass="btn-remove" 
                                CommandName="Remove" CommandArgument='<%# Convert.ToString(Eval("cID")) %>' 
                                OnClientClick="return confirm('Are you sure you want to remove this item?');"/>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <div style="padding: 20px 0px;">
        <h4>Total Amount: RM<asp:Label ID="lblGrandTotal" runat="server" Text="0.00"></asp:Label></h4>
        <asp:Button ID="btnCheckout" runat="server" Text="Checkout" CssClass="btn-action" onClick="btnCheckout_Click" OnClientClick="return confirm('Proceed to checkout?');" />
        <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClientClick="history.back(); return false;"/>
    </div>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>" 
        ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
        SelectCommand="
            SELECT 
    Cart.cID, Cart.formatted_cID,
    Cart.fID,  
    Food.fName,  
    Cart.quantity,  
    Food.fPrice,  
    (Cart.quantity * Food.fPrice) AS TotalPrice
FROM Cart 
INNER JOIN Food ON Cart.fID = Food.fID 
WHERE Cart.uID = @uID;
;">
        <SelectParameters>
            <asp:SessionParameter Name="uID" SessionField="uID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>